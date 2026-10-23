import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:reakt_app/services/local_store.dart';
import 'package:reakt_app/services/snapshot.dart';
import 'package:reakt_app/services/cloud_sync.dart';
import 'snapshot_test.dart' as sample;

void main() {
  late Directory dir;
  late LocalStore store;
  setUp(() async {
    sqfliteFfiInit();
    sqlite.databaseFactory = databaseFactoryFfi;
    dir = await Directory.systemTemp.createTemp('reakt-store-');
    store = await LocalStore.open(databasePath: '${dir.path}/sessions.db');
  });
  tearDown(() async {
    await store.db.close();
    await dir.delete(recursive: true);
  });
  test(
    'survives close and reopen; replay does not duplicate or clear sync',
    () async {
      final snapshot = TrainingSnapshot.parse(sample.fixture());
      await store.save(snapshot);
      await store.bind(snapshot.id, 'user-a');
      await store.markSynced(snapshot.id, jsonEncode(snapshot.data), 'user-a');
      await store.db.close();
      store = await LocalStore.open(databasePath: '${dir.path}/sessions.db');
      await store.save(snapshot);
      final rows = await store.rows();
      expect(rows.length, 1);
      expect(rows.single['synced'], 1);
      expect(rows.single['owner'], 'user-a');
    },
  );
  test(
    'stale cloud acknowledgement cannot mark a newer payload synced',
    () async {
      final snapshot = TrainingSnapshot.parse(sample.fixture());
      await store.save(snapshot);
      await store.bind(snapshot.id, 'user-a');
      final updated = sample.fixture()..['status'] = 'interrupted';
      await store.save(TrainingSnapshot.parse(updated));
      await store.markSynced(snapshot.id, jsonEncode(snapshot.data), 'user-a');
      expect((await store.rows()).single['synced'], 0);
    },
  );
  test('account binding is stable', () async {
    final snapshot = TrainingSnapshot.parse(sample.fixture());
    await store.save(snapshot);
    await store.bind(snapshot.id, 'user-a');
    await store.bind(snapshot.id, 'user-b');
    await store.markSynced(snapshot.id, jsonEncode(snapshot.data), 'user-b');
    final row = (await store.rows()).single;
    expect(row['owner'], 'user-a');
    expect(row['synced'], 0);
  });
  test(
    'offline and partial cloud writes retry without duplicate rows',
    () async {
      final snapshot = TrainingSnapshot.parse(sample.fixture());
      await store.save(snapshot);
      final remote = MemorySessionRemote('user-a')..online = false;
      final sync = CloudSync(store, remote);
      await expectLater(sync.sync(), throwsStateError);
      expect((await store.rows()).single['synced'], 0);
      remote.online = true;
      remote.failResults = true;
      await expectLater(sync.sync(), throwsStateError);
      expect(remote.sessions.length, 1);
      expect(remote.results, isEmpty);
      expect((await store.rows()).single['synced'], 0);
      remote.failResults = false;
      expect(await sync.sync(), 1);
      expect(await sync.sync(), 0);
      expect(remote.sessions.length, 1);
      expect(remote.results.length, 1);
      expect(remote.eventRows.length, 1);
      expect((await store.rows()).single['synced'], 1);
    },
  );
  test('different account cannot upload an owned pending session', () async {
    final snapshot = TrainingSnapshot.parse(sample.fixture());
    await store.save(snapshot);
    await store.bind(snapshot.id, 'user-a');
    final remote = MemorySessionRemote('user-b');
    expect(await CloudSync(store, remote).sync(), 0);
    expect(remote.sessions, isEmpty);
  });
  test(
    'export preserves pending snapshots and account without authentication material',
    () async {
      final snapshot = TrainingSnapshot.parse(sample.fixture());
      await store.save(snapshot);
      await store.bind(snapshot.id, 'user-a');
      final result =
          jsonDecode(await store.exportJson()) as Map<String, dynamic>;
      expect(result['format'], 'reakt-history-v1');
      final row = (result['sessions'] as List).single as Map<String, dynamic>;
      expect(row['synced'], false);
      expect(row['owner'], 'user-a');
      expect(row['snapshot']['session_id'], snapshot.id);
      expect(row['snapshot']['hits'], 1);
      expect(row.containsKey('password'), false);
    },
  );
}
