import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'snapshot_test.dart' as sample;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:reakt_app/main.dart';
import 'package:reakt_app/services/local_store.dart';

class _RealHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context);
}

void main() {
  late LocalStore store;
  setUp(() async {
    sqfliteFfiInit();
    sqlite.databaseFactory = databaseFactoryFfi;
    store = await LocalStore.open(databasePath: inMemoryDatabasePath);
  });
  tearDown(() async => store.db.close());
  testWidgets(
    'offline training screen renders and prevents disconnected start',
    (tester) async {
      await tester.pumpWidget(ReaktApp(store: store));
      expect(find.text('REAKT · Entrenamiento'), findsOneWidget);
      expect(find.text('Gateway sin conexión'), findsOneWidget);
      final manual = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Prueba manual · 5 segundos'),
      );
      final start = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Reflejos · 10 rondas · 1,5 s'),
      );
      expect(manual.onPressed, isNull);
      expect(start.onPressed, isNull);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'training UI sends manual command and persists returned WebSocket result',
    (tester) async {
      late HttpServer server;
      final sockets = <WebSocket>[];
      final received = Completer<Map<String, dynamic>>();
      await tester.runAsync(() async {
        server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        server.listen((request) async {
          final socket = await WebSocketTransformer.upgrade(request);
          sockets.add(socket);
          socket.add(jsonEncode(sample.fixture()));
          socket.listen((raw) {
            final command = jsonDecode(raw as String) as Map<String, dynamic>;
            if (!received.isCompleted) received.complete(command);
            final result = sample.fixture();
            result['session_id'] = 'abcdef01-1234-4567-8123-123456789abc';
            (result['events'] as List).first['id'] =
                '${result['session_id']}:1';
            socket.add(jsonEncode(result));
          });
        });
      });
      Future<void> waitForRows(int count) async {
        // Advance Flutter's fake microtasks between real SQLite/WebSocket IO.
        for (var attempt = 0; attempt < 250; attempt++) {
          await tester.pump();
          final rows = await tester.runAsync(() => store.rows());
          if (rows!.length == count) return;
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 20)),
          );
        }
        throw StateError(
          'Snapshot persistence timeout: sockets=${sockets.length}',
        );
      }

      try {
        await tester.pumpWidget(ReaktApp(store: store));
        await tester.enterText(
          find.byType(TextField).first,
          'ws://127.0.0.1:${server.port}',
        );
        await tester.runAsync(() async {
          await HttpOverrides.runWithHttpOverrides(() async {
            tester
                .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Conectar gateway'),
                )
                .onPressed!();
            await Future<void>.delayed(const Duration(milliseconds: 20));
          }, _RealHttpOverrides());
        });
        await waitForRows(1);
        await tester.pumpAndSettle();
        expect(find.text('Gateway conectada'), findsOneWidget);
        final manual = find.widgetWithText(
          FilledButton,
          'Prueba manual · 5 segundos',
        );
        await tester.ensureVisible(manual);
        await tester.runAsync(() async {
          tester.widget<FilledButton>(manual).onPressed!();
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        await waitForRows(2);
        expect(
          (await tester.runAsync(() => received.future))!['command'],
          'manual',
        );
        await tester.pumpAndSettle();
        expect(find.text('Aciertos 1'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(() async {
          for (final socket in sockets) {
            await socket.close();
          }
          await server.close(force: true);
        });
      }
    },
  );
}
