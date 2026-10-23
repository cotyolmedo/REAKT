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
      expect(find.text('Iniciar entrenamiento'), findsOneWidget);
      await tester.tap(find.text('Iniciar entrenamiento'));
      await tester.pumpAndSettle();
      expect(find.text('Gateway sin conexión'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Comenzar sesión'),
        300,
        scrollable: find
            .descendant(
              of: find.byKey(const PageStorageKey(1)),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      final manual = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Prueba manual · 5 segundos'),
      );
      final start = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Comenzar sesión'),
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
      final configuredStart = Completer<Map<String, dynamic>>();
      await tester.runAsync(() async {
        server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        server.listen((request) async {
          final socket = await WebSocketTransformer.upgrade(request);
          sockets.add(socket);
          socket.add(jsonEncode(sample.fixture()));
          socket.listen((raw) {
            final command = jsonDecode(raw as String) as Map<String, dynamic>;
            if (!received.isCompleted) received.complete(command);
            if (command['command'] == 'start' && !configuredStart.isCompleted)
              configuredStart.complete(command);
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
        await tester.tap(find.text('Iniciar entrenamiento'));
        await tester.pumpAndSettle();
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
          OutlinedButton,
          'Prueba manual · 5 segundos',
        );
        await tester.scrollUntilVisible(
          manual,
          250,
          scrollable: find
              .descendant(
                of: find.byKey(const PageStorageKey(1)),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await tester.runAsync(() async {
          tester.widget<OutlinedButton>(manual).onPressed!();
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        await waitForRows(2);
        expect(
          (await tester.runAsync(() => received.future))!['command'],
          'manual',
        );
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Reacción'),
          250,
          scrollable: find
              .descendant(
                of: find.byKey(const PageStorageKey(1)),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(find.text('250.0 ms'), findsOneWidget);
        final scrollable = find
            .descendant(
              of: find.byKey(const PageStorageKey(1)),
              matching: find.byType(Scrollable),
            )
            .first;
        await tester.scrollUntilVisible(
          find.text('10 rondas'),
          -250,
          scrollable: scrollable,
        );
        await tester.ensureVisible(find.byType(DropdownButtonFormField<int>).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('10 rondas'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('20 rondas').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('1.5 s'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('3.0 s').last);
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Comenzar sesión'),
          200,
          scrollable: scrollable,
        );
        await tester.runAsync(() async {
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Comenzar sesión'),
              )
              .onPressed!();
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        final command = await tester.runAsync(
          () => configuredStart.future.timeout(const Duration(seconds: 3)),
        );
        expect(command!['rounds'], 20);
        expect(command['limit_ms'], 3000);
        await tester.pumpAndSettle();
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
