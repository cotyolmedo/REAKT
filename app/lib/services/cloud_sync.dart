import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_store.dart';
import 'snapshot.dart';

abstract class SessionRemote {
  String? get userId;
  Future<void> session(Map<String, dynamic> row);
  Future<void> result(Map<String, dynamic> row);
  Future<void> events(List<Map<String, dynamic>> rows);
}

class SupabaseRemote implements SessionRemote {
  final SupabaseClient client;
  SupabaseRemote(this.client);
  @override
  String? get userId => client.auth.currentUser?.id;
  @override
  Future<void> session(Map<String, dynamic> row) async {
    await client.from('reakt_sessions').upsert(row);
  }

  @override
  Future<void> result(Map<String, dynamic> row) async {
    await client.from('reakt_results').upsert(row);
  }

  @override
  Future<void> events(List<Map<String, dynamic>> rows) async {
    await client.from('reakt_events').upsert(rows);
  }
}

// Test repository only; never substituted for authenticated remote writes in the app.
class MemorySessionRemote implements SessionRemote {
  @override
  String? userId;
  bool online = true, failResults = false;
  final sessions = <String, Map<String, dynamic>>{};
  final results = <String, Map<String, dynamic>>{};
  final eventRows = <String, Map<String, dynamic>>{};
  MemorySessionRemote(this.userId);
  void _check() {
    if (!online || userId == null)
      throw StateError('Simulated cloud unavailable');
  }

  @override
  Future<void> session(Map<String, dynamic> row) async {
    _check();
    sessions[row['id'] as String] = Map.from(row);
  }

  @override
  Future<void> result(Map<String, dynamic> row) async {
    _check();
    if (failResults) throw StateError('Simulated partial write failure');
    results[row['session_id'] as String] = Map.from(row);
  }

  @override
  Future<void> events(List<Map<String, dynamic>> rows) async {
    _check();
    for (final row in rows) {
      eventRows[row['id'] as String] = Map.from(row);
    }
  }
}

class CloudSync {
  final LocalStore store;
  final SessionRemote? remote;
  bool _busy = false;
  CloudSync(this.store, this.remote);
  Future<int> sync() async {
    if (_busy) return 0;
    final api = remote;
    final uid = api?.userId;
    if (api == null || uid == null)
      throw StateError('Iniciá sesión en Supabase primero');
    _busy = true;
    int count = 0;
    try {
      for (final row in await store.rows()) {
        if (row['synced'] == 1 || (row['owner'] != null && row['owner'] != uid))
          continue;
        final payload = row['payload'] as String;
        final s = TrainingSnapshot.parse(jsonDecode(payload));
        if (!s.finished) continue;
        if (api.userId != uid)
          throw StateError('La cuenta cambió durante la sincronización');
        if (!await store.bind(s.id, uid)) continue;
        // Separate idempotent upserts. Local ACK only after every write succeeds.
        await api.session({
          'id': s.id,
          'user_id': uid,
          'status': s.status,
          'rounds': s.number('rounds'),
          'limit_ms': s.number('limit_ms'),
          'captured_at': row['captured_at'],
        });
        if (api.userId != uid)
          throw StateError('La cuenta cambió durante la sincronización');
        await api.result({
          'session_id': s.id,
          'user_id': uid,
          'hits': s.number('hits'),
          'misses': s.number('misses'),
          'early': s.number('early'),
          'mean_us': s.number('mean_us'),
        });
        if (api.userId != uid)
          throw StateError('La cuenta cambió durante la sincronización');
        if (s.events.isNotEmpty) {
          await api.events(
            s.events
                .map(
                  (e) => {
                    'id': e['id'],
                    'session_id': s.id,
                    'user_id': uid,
                    'round': e['round'],
                    'node': e['node'],
                    'kind': e['kind'],
                    'reaction_us': e['reaction_us'],
                  },
                )
                .toList(),
          );
        }
        await store.markSynced(s.id, payload, uid);
        count++;
      }
      return count;
    } finally {
      _busy = false;
    }
  }
}
