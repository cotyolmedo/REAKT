import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:reakt_app/main.dart';
import 'package:reakt_app/services/local_store.dart';
import 'package:reakt_app/services/snapshot.dart';
import 'snapshot_test.dart' as sample;

void main() {
  late LocalStore store;
  setUp(() async {
    sqfliteFfiInit();
    sqlite.databaseFactory = databaseFactoryFfi;
    store = await LocalStore.open(databasePath: inMemoryDatabasePath);
  });
  tearDown(() async => store.db.close());

  for (final width in [320.0, 390.0, 800.0]) {
    testWidgets('navigation and measured history at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(
        () => store.save(TrainingSnapshot.parse(sample.fixture())),
      );
      const capture = bool.fromEnvironment('REAKT_CAPTURE_UI');
      if (capture) {
        // Only preview rendering uses a local font; no font files ship in the app.
        final font = File('C:/Windows/Fonts/segoeui.ttf');
        final bytes = await tester.runAsync(() => font.readAsBytes());
        await (FontLoader(
          'Roboto',
        )..addFont(Future.value(ByteData.sublistView(bytes!)))).load();
        await (FontLoader(
          'Ahem',
        )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
        await (FontLoader(
          'MaterialIcons',
        )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
      }
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: ReaktApp(store: store),
        ),
      );
      await tester.pump();
      await tester.runAsync(() => store.rows());
      await tester.pumpAndSettle();

      Future<void> screenshot(String name) async {
        if (!capture || width != 390) return;
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final dir = Directory('../.school-work/flutter-preview');
          await dir.create(recursive: true);
          await File(
            '${dir.path}/$name.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      await screenshot('inicio');
      final nav = find.byType(NavigationBar);
      for (final label in [
        'Historial',
        'Progreso',
        'Perfil',
        'Entrenar',
        'Inicio',
      ]) {
        await tester.tap(find.descendant(of: nav, matching: find.text(label)));
        await tester.pump();
        await tester.runAsync(() => store.rows());
        await tester.pumpAndSettle();
        if (label == 'Historial') {
          expect(find.text('Sesión · Completada'), findsOneWidget);
          await tester.tap(find.text('Sesión · Completada'));
          await tester.pumpAndSettle();
          expect(find.text('250.0 ms'), findsOneWidget);
        }
        if (label == 'Progreso') {
          expect(find.text('100%'), findsOneWidget);
          expect(find.text('250.0 ms'), findsOneWidget);
        }
        if (label == 'Entrenar') {
          expect(find.text('Gateway sin conexión'), findsOneWidget);
        }
        await screenshot(label.toLowerCase());
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('empty history and progress have no invented measurements', (
    tester,
  ) async {
    await tester.pumpWidget(ReaktApp(store: store));
    await tester.pump();
    await tester.runAsync(() => store.rows());
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Progreso'),
      ),
    );
    await tester.pump();
    await tester.runAsync(() => store.rows());
    await tester.pumpAndSettle();
    expect(find.text('—'), findsNWidgets(2));
    expect(find.textContaining('Completá una sesión'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
