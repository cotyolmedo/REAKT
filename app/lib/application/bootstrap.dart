part of '../main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_ANON_KEY');
    SupabaseClient? cloud;
    String cloudError = "";
    if (url.isNotEmpty && key.isNotEmpty) {
      try {
        if (!url.startsWith('https://'))
          throw StateError('Supabase requiere HTTPS');
        await Supabase.initialize(
          url: url,
          anonKey: key,
        ).timeout(const Duration(seconds: 8));
        cloud = Supabase.instance.client;
      } catch (_) {
        cloudError =
            'Supabase no disponible al iniciar. Entrenamiento local habilitado; reabrí la app con Internet para iniciar sesión.';
      }
    }
    final store = await LocalStore.open();
    runApp(ReaktApp(store: store, cloud: cloud, cloudError: cloudError));
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No se pudo iniciar REAKT. No se borraron datos.\n$e',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
