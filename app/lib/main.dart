import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/local_store.dart';
import 'services/gateway_link.dart';
import 'services/cloud_sync.dart';

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

class ReaktApp extends StatelessWidget {
  final LocalStore store;
  final SupabaseClient? cloud;
  final String cloudError;
  const ReaktApp({
    super.key,
    required this.store,
    this.cloud,
    this.cloudError = "",
  });
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'REAKT',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFFE3262E),
      scaffoldBackgroundColor: const Color(0xFF070707),
      useMaterial3: true,
    ),
    home: TrainingPage(store: store, cloud: cloud, cloudError: cloudError),
  );
}

class TrainingPage extends StatefulWidget {
  final LocalStore store;
  final SupabaseClient? cloud;
  final String cloudError;
  const TrainingPage({
    super.key,
    required this.store,
    this.cloud,
    this.cloudError = "",
  });
  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage>
    with WidgetsBindingObserver {
  late final GatewayLink link;
  late final CloudSync cloudSync;
  final address = TextEditingController(text: 'ws://192.168.4.1:81');
  final email = TextEditingController(), password = TextEditingController();
  StreamSubscription<AuthState>? authSubscription;
  Timer? syncTimer;
  String message = '';
  bool busy = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    link = GatewayLink(widget.store)..addListener(changed);
    cloudSync = CloudSync(
      widget.store,
      widget.cloud == null ? null : SupabaseRemote(widget.cloud!),
    );
    authSubscription = widget.cloud?.auth.onAuthStateChange.listen(
      (_) => changed(),
    );
    syncTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (widget.cloud?.auth.currentUser != null) unawaited(sync(silent: true));
    });
  }

  void changed() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        widget.cloud?.auth.currentUser != null)
      unawaited(sync(silent: true));
  }

  Future<void> action(Future<void> Function() work) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await work();
    } catch (e) {
      if (mounted) setState(() => message = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> sync({bool silent = false}) async {
    try {
      await link.flush();
      final n = await cloudSync.sync();
      if (mounted && (!silent || n > 0))
        setState(() => message = '$n sesiones sincronizadas');
    } catch (e) {
      if (mounted) setState(() => message = 'Pendiente de sincronizar: $e');
    }
  }

  Future<void> history() async {
    await link.flush();
    final rows = await widget.store.rows();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Historial local'),
            content: SizedBox(
              width: 420,
              height: 320,
              child: ListView(
                children:
                    rows
                        .map(
                          (r) => ListTile(
                            title: Text('${r['id']}'),
                            subtitle: Text(
                              '${r['captured_at']}\n${r['synced'] == 1 ? 'Sincronizada' : 'Guardada localmente'}',
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  Future<void> exportHistory() async {
    await link.flush();
    await Clipboard.setData(
      ClipboardData(text: await widget.store.exportJson()),
    );
    if (mounted)
      setState(
        () =>
            message =
                'Historial copiado. Pegalo en un archivo y guardalo antes de cambiar de instalación.',
      );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    syncTimer?.cancel();
    authSubscription?.cancel();
    link.removeListener(changed);
    link.dispose();
    address.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = link.snapshot;
    final training = s?.data['active'] == true;
    final user = widget.cloud?.auth.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('REAKT · Entrenamiento')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Entrená con intención.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Conectá el teléfono al Wi-Fi REAKT-MVP. El entrenamiento funciona sin Internet.',
          ),
          TextField(
            controller: address,
            decoration: const InputDecoration(labelText: 'Gateway WebSocket'),
          ),
          FilledButton(
            onPressed:
                busy
                    ? null
                    : () => action(() => link.connect(address.text.trim())),
            child: Text(
              link.connected ? 'Reconectar gateway' : 'Conectar gateway',
            ),
          ),
          Text(link.connected ? 'Gateway conectada' : 'Gateway sin conexión'),
          if (link.error.isNotEmpty)
            Text(
              link.error,
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          const SizedBox(height: 20),
          Text(
            'Estado: ${s?.status ?? 'sin datos'} · Ronda ${s?.data['round'] ?? 0}/${s?.data['rounds'] ?? 0}',
          ),
          Text('Nodo objetivo: ${s?.data['target'] ?? '—'}'),
          const Text(
            'Sin LEDs verificados, usá estas pruebas solo para comprobar mensajes y pulsador; no para medir reacción visual.',
          ),
          Wrap(
            spacing: 12,
            children: [
              Chip(label: Text('Aciertos ${s?.data['hits'] ?? 0}')),
              Chip(label: Text('Fallos ${s?.data['misses'] ?? 0}')),
              Chip(label: Text('Anticipadas ${s?.data['early'] ?? 0}')),
              Chip(
                label: Text(
                  'Reacción ${((s?.data['mean_us'] ?? 0) / 1000).toStringAsFixed(1)} ms',
                ),
              ),
            ],
          ),
          FilledButton(
            onPressed:
                !link.connected || training || busy
                    ? null
                    : () => action(() => link.command('manual', limitMs: 5000)),
            child: const Text('Prueba manual · 5 segundos'),
          ),
          FilledButton(
            onPressed:
                !link.connected || training || busy
                    ? null
                    : () => action(() => link.command('start')),
            child: const Text('Reflejos · 10 rondas · 1,5 s'),
          ),
          OutlinedButton(
            onPressed:
                !link.connected || !training || busy
                    ? null
                    : () => action(() => link.command('stop')),
            child: const Text('Detener sesión'),
          ),
          Text(
            'Diagnóstico: ${s?.data['diagnostics'] ?? '—'}\n${s?.data['error'] ?? ''}',
          ),
          TextButton(
            onPressed: () => action(history),
            child: const Text('Ver historial guardado'),
          ),
          TextButton(
            onPressed: busy ? null : () => action(exportHistory),
            child: const Text('Copiar historial JSON'),
          ),
          const Divider(height: 32),
          const Text('Sincronización Supabase', style: TextStyle(fontSize: 20)),
          if (widget.cloudError.isNotEmpty) Text(widget.cloudError),
          if (widget.cloud == null)
            const Text(
              'Sin configurar. Las sesiones se conservan en este teléfono. Usar SUPABASE_URL y SUPABASE_ANON_KEY al compilar.',
            ),
          if (widget.cloud != null && user == null) ...[
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo del usuario de pruebas',
              ),
            ),
            TextField(
              controller: password,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            FilledButton(
              onPressed:
                  busy
                      ? null
                      : () => action(() async {
                        await widget.cloud!.auth.signInWithPassword(
                          email: email.text.trim(),
                          password: password.text,
                        );
                        password.clear();
                      }),
              child: const Text('Iniciar sesión'),
            ),
          ],
          if (user != null) ...[
            Text(
              'Cuenta: ${user.email ?? user.id}. Las sesiones sin propietario se asignarán a esta cuenta al sincronizar.',
            ),
            FilledButton(
              onPressed: busy ? null : () => action(() => sync()),
              child: const Text('Sincronizar sesiones finalizadas'),
            ),
            TextButton(
              onPressed:
                  busy
                      ? null
                      : () => action(() => widget.cloud!.auth.signOut()),
              child: const Text('Cerrar sesión'),
            ),
          ],
          if (message.isNotEmpty) Text(message),
          const Text(
            'La conexión a Internet se usa solo para iniciar sesión y sincronizar. Volvé a una red con Internet después del entrenamiento.',
          ),
        ],
      ),
    );
  }
}
