import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'snapshot.dart';

class LocalStore {
  final Database db;
  LocalStore(this.db);
  static Future<LocalStore> open({String? databasePath}) async {
    final db = await openDatabase(
      databasePath ?? path.join(await getDatabasesPath(), 'reakt_mvp.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute(
          'CREATE TABLE sessions (id TEXT PRIMARY KEY, owner TEXT, payload TEXT NOT NULL, captured_at TEXT NOT NULL, synced INTEGER NOT NULL DEFAULT 0)',
        );
      },
    );
    return LocalStore(db);
  }

  Future<void> save(TrainingSnapshot snapshot) async {
    if (snapshot.id.isEmpty) return;
    final payload = jsonEncode(snapshot.data);
    await db.transaction((tx) async {
      final old = await tx.query(
        'sessions',
        where: 'id = ?',
        whereArgs: [snapshot.id],
      );
      if (old.isNotEmpty && old.first['payload'] == payload) return;
      // Preserve account ownership and first capture time across reconnect snapshots.
      await tx.insert('sessions', {
        'id': snapshot.id,
        'owner': old.isEmpty ? null : old.first['owner'],
        'payload': payload,
        'captured_at':
            old.isEmpty
                ? DateTime.now().toUtc().toIso8601String()
                : old.first['captured_at'],
        'synced': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Map<String, Object?>>> rows() =>
      db.query('sessions', orderBy: 'captured_at DESC');
  Future<String> exportJson() async {
    final entries = await rows();
    return jsonEncode({
      'format': 'reakt-history-v1',
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'sessions':
          entries
              .map(
                (row) => {
                  'id': row['id'],
                  'owner': row['owner'],
                  'captured_at': row['captured_at'],
                  'synced': row['synced'] == 1,
                  'snapshot': jsonDecode(row['payload'] as String),
                },
              )
              .toList(),
    });
  }

  Future<bool> bind(String id, String uid) async {
    await db.rawUpdate(
      'UPDATE sessions SET owner = ? WHERE id = ? AND owner IS NULL',
      [uid, id],
    );
    final row = await db.query(
      'sessions',
      columns: ['owner'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return row.isNotEmpty && row.single['owner'] == uid;
  }

  Future<void> markSynced(String id, String payload, String uid) async {
    await db.rawUpdate(
      'UPDATE sessions SET synced = 1 WHERE id = ? AND payload = ? AND owner = ?',
      [id, payload, uid],
    );
  }
}
