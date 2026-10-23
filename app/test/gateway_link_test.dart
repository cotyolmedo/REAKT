import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:reakt_app/services/local_store.dart';
import 'package:reakt_app/services/snapshot.dart';
import 'package:reakt_app/services/gateway_link.dart';
import 'snapshot_test.dart' as sample;

class FailingStore extends LocalStore {
  FailingStore(super.db);
  @override
  Future<void> save(TrainingSnapshot snapshot) async {
    throw StateError('disk unavailable');
  }
}

class BlockingStore extends LocalStore {
  final gate = Completer<void>();
  BlockingStore(super.db);
  @override
  Future<void> save(TrainingSnapshot snapshot) async {
    await gate.future;
    await super.save(snapshot);
  }
}

Future<void> connected(GatewayLink link, String address) async {
  final ready = Completer<void>();
  void changed() {
    if (link.connected && !ready.isCompleted) ready.complete();
  }

  link.addListener(changed);
  await link.connect(address);
  await ready.future.timeout(const Duration(seconds: 5));
  link.removeListener(changed);
}

void main() {
  late LocalStore store;
  late HttpServer server;
  late List<WebSocket> sockets;
  late List<Map<String, dynamic>> commands;
  GatewayLink? link;
  setUp(() async {
    sqfliteFfiInit();
    sqlite.databaseFactory = databaseFactoryFfi;
    store = await LocalStore.open(databasePath: inMemoryDatabasePath);
    sockets = [];
    commands = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      final socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      socket.add(jsonEncode(sample.fixture()));
      socket.listen((raw) {
        commands.add(jsonDecode(raw as String) as Map<String, dynamic>);
      });
    });
  });
  tearDown(() async {
    link?.dispose();
    link = null;
    for (final socket in sockets) {
      await socket.close();
    }
    await server.close(force: true);
    await store.db.close();
  });
  test('persists snapshot before start command and rejects bad URLs', () async {
    link = GatewayLink(store);
    await link!.connect('https://example.com');
    expect(link!.connected, false);
    await connected(link!, 'ws://127.0.0.1:${server.port}');
    await link!.command('start');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect((await store.rows()).length, 1);
    expect(commands.single['command'], 'start');
  });
  test('storage failure blocks new session but permits stop', () async {
    link = GatewayLink(FailingStore(store.db));
    await connected(link!, 'ws://127.0.0.1:${server.port}');
    await link!.flush();
    await expectLater(link!.command('start'), throwsStateError);
    await link!.command('stop');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(commands.single['command'], 'stop');
  });
  test(
    'disconnect while waiting for disk cannot send on a changed connection',
    () async {
      final blocked = BlockingStore(store.db);
      link = GatewayLink(blocked);
      await connected(link!, 'ws://127.0.0.1:${server.port}');
      final request = link!.command('start');
      final check = expectLater(request, throwsStateError);
      link!.disconnect();
      blocked.gate.complete();
      await check;
      expect(commands, isEmpty);
    },
  );
  test(
    'automatically reconnects and replays retained snapshot without duplicate local session',
    () async {
      link = GatewayLink(store);
      await connected(link!, 'ws://127.0.0.1:${server.port}');
      await link!.flush();
      final recovered = Completer<void>();
      void changed() {
        if (link!.connected && sockets.length >= 2 && !recovered.isCompleted)
          recovered.complete();
      }

      link!.addListener(changed);
      await sockets.first.close(WebSocketStatus.goingAway);
      await recovered.future.timeout(const Duration(seconds: 5));
      link!.removeListener(changed);
      await link!.flush();
      expect(sockets.length, 2);
      expect((await store.rows()).length, 1);
      expect(link!.snapshot!.id, sample.fixture()['session_id']);
    },
  );
}
