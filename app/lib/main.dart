import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/local_store.dart';
import 'services/gateway_link.dart';
import 'services/cloud_sync.dart';
import 'presentation/components.dart';
import 'presentation/session_record.dart';

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
      scaffoldBackgroundColor: ReaktColors.background,
      appBarTheme: const AppBarTheme(backgroundColor: ReaktColors.background),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ReaktColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
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
  int tab = 0, rounds = 10, limitMs = 1500;
  List<SessionRecord> records = [];
  bool historyLoading = true;
  String historyError = '';
  int _historyGeneration = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    link = GatewayLink(widget.store)..addListener(changed);
    cloudSync = CloudSync(
      widget.store,
      widget.cloud == null ? null : SupabaseRemote(widget.cloud!),
    );
    unawaited(loadHistory());
    authSubscription = widget.cloud?.auth.onAuthStateChange.listen(
      (_) => changed(),
    );
    syncTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (widget.cloud?.auth.currentUser != null) unawaited(sync(silent: true));
    });
  }

  void changed() {
    if (mounted) {
      setState(() {});
      unawaited(loadHistory());
    }
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
      await loadHistory();
      if (mounted && (!silent || n > 0))
        setState(() => message = '$n sesiones sincronizadas');
    } catch (e) {
      if (mounted) setState(() => message = 'Pendiente de sincronizar: $e');
    }
  }

  Future<void> loadHistory() async {
    final generation = ++_historyGeneration;
    try {
      await link.flush();
      final rows = await widget.store.rows();
      final next = <SessionRecord>[];
      int rejected = 0;
      for (final row in rows) {
        try {
          next.add(SessionRecord.fromRow(row));
        } catch (_) {
          rejected++;
        }
      }
      if (!mounted || generation != _historyGeneration) return;
      setState(() {
        records = next;
        historyLoading = false;
        historyError = rejected == 0
            ? ''
            : '$rejected registros no se pudieron interpretar. Se conservan para exportación.';
      });
    } catch (_) {
      if (!mounted || generation != _historyGeneration) return;
      setState(() {
        historyLoading = false;
        historyError = 'No se pudo leer el historial. Intentá actualizar.';
      });
    }
  }

  Future<void> exportHistory() async {
    await link.flush();
    await Clipboard.setData(
      ClipboardData(text: await widget.store.exportJson()),
    );
    if (mounted)
      setState(
        () => message =
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

  void navigate(int value) {
    setState(() => tab = value);
    if (value == 2 || value == 3) unawaited(loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final views = [_home, _training, _history, _progress, _profile];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/brand/reakt-symbol.png',
              width: 36,
              height: 36,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/brand/reakt-wordmark.png',
              width: 126,
              height: 28,
              fit: BoxFit.cover,
              semanticLabel: 'REAKT',
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => navigate(1),
            tooltip: link.connected
                ? 'Gateway conectada'
                : 'Gateway sin conexión',
            icon: Icon(link.connected ? Icons.wifi : Icons.wifi_off, size: 18),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                if (message.isNotEmpty)
                  MaterialBanner(
                    content: Text(message),
                    actions: [
                      TextButton(
                        onPressed: () => setState(() => message = ''),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView(
                    key: PageStorageKey(tab),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: [
                      if (historyError.isNotEmpty)
                        Text(
                          historyError,
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                      ...views[tab](),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: navigate,
        backgroundColor: ReaktColors.card,
        indicatorColor: ReaktColors.accent.withValues(alpha: .3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt),
            label: 'Entrenar',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Historial',
          ),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Progreso'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  List<Widget> _home() {
    final latest = records.isEmpty ? null : records.first;
    return [
      Container(
        padding: const EdgeInsets.all(28),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF691A20), Color(0xFF230B0E)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/brand/reakt-symbol.png',
              width: 64,
              height: 64,
              semanticLabel: 'Logo REAKT',
            ),
            const SizedBox(height: 24),
            const Text(
              'CADA RESPUESTA CUENTA',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w800,
                color: ReaktColors.soft,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Entrená con fuerza.\nReaccioná con intención.',
              style: TextStyle(
                fontSize: 32,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Iniciá tu sesión, registrá tus respuestas y seguí tu evolución con REAKT.',
              style: TextStyle(height: 1.5, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => navigate(1),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar entrenamiento'),
              ),
            ),
          ],
        ),
      ),
      ActionCard(
        icon: Icons.history,
        title: 'Última sesión',
        subtitle: latest == null
            ? (historyLoading
                  ? 'Cargando historial…'
                  : 'Tu próxima sesión empieza tu historia.')
            : '${sessionStatus(latest.snapshot.status)} · ${precision(latest.snapshot)} precisión · ${reaction(latest.snapshot)}',
        onTap: () => navigate(2),
      ),
      ActionCard(
        icon: Icons.calendar_month,
        title: 'Revisar historial',
        subtitle: 'Consultá tus días entrenados y métricas por sesión.',
        onTap: () => navigate(2),
      ),
      ActionCard(
        icon: Icons.insights,
        title: 'Ver progreso',
        subtitle: 'Compará tu precisión y tu tiempo de respuesta.',
        onTap: () => navigate(3),
      ),
    ];
  }

  Widget _connection() => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          link.connected ? 'Gateway conectada' : 'Gateway sin conexión',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Conectá el teléfono al Wi-Fi REAKT-MVP. Podés entrenar sin Internet.',
          style: TextStyle(color: ReaktColors.muted),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: address,
          autocorrect: false,
          decoration: const InputDecoration(labelText: 'Gateway WebSocket'),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: busy
                  ? null
                  : () => action(() => link.connect(address.text.trim())),
              child: Text(
                link.connected ? 'Reconectar gateway' : 'Conectar gateway',
              ),
            ),
            OutlinedButton(
              onPressed: () => link.disconnect(),
              child: const Text('Desconectar'),
            ),
          ],
        ),
        if (link.error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              link.error,
              style: const TextStyle(color: Colors.orangeAccent),
            ),
          ),
      ],
    ),
  );

  List<Widget> _training() {
    final s = link.snapshot;
    final training = s?.data['active'] == true;
    final editable = !training && !busy;
    return [
      const PageHeading(
        'Entrenamiento',
        'Prepará tus módulos. Elegí tu desafío.',
      ),
      _connection(),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.bolt, color: ReaktColors.soft),
              title: Text(
                'Reflejos',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('Respondé al objetivo indicado por el gateway.'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: rounds,
              decoration: const InputDecoration(labelText: 'Rondas'),
              items: [5, 10, 20, 30, 50]
                  .map(
                    (n) => DropdownMenuItem(value: n, child: Text('$n rondas')),
                  )
                  .toList(),
              onChanged: editable
                  ? (value) => setState(() => rounds = value!)
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: limitMs,
              decoration: const InputDecoration(
                labelText: 'Tiempo por estímulo',
              ),
              items: [500, 1000, 1500, 3000, 5000]
                  .map(
                    (n) => DropdownMenuItem(
                      value: n,
                      child: Text('${(n / 1000).toStringAsFixed(1)} s'),
                    ),
                  )
                  .toList(),
              onChanged: editable
                  ? (value) => setState(() => limitMs = value!)
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: !link.connected || !editable
                    ? null
                    : () => action(
                        () => link.command(
                          'start',
                          rounds: rounds,
                          limitMs: limitMs,
                        ),
                      ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Comenzar sesión'),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: !link.connected || !editable
                      ? null
                      : () =>
                            action(() => link.command('manual', limitMs: 5000)),
                  child: const Text('Prueba manual · 5 segundos'),
                ),
                OutlinedButton(
                  onPressed: !link.connected || !training || busy
                      ? null
                      : () => action(() => link.command('stop')),
                  child: const Text('Detener sesión'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Memoria, agilidad, velocidad, resistencia, precisión y coordinación: pendientes de implementación.',
              style: TextStyle(color: ReaktColors.muted),
            ),
          ],
        ),
      ),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s == null
                  ? 'Esperando tu primera conexión'
                  : '${sessionStatus(s.status)} · Ronda ${s.number('round')}/${s.number('rounds')}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            if (!link.connected && s != null)
              const Text(
                'Último estado recibido. Reconectá para actualizar.',
                style: TextStyle(color: Colors.orangeAccent),
              ),
            const SizedBox(height: 12),
            if (s != null && s.number('rounds') > 0)
              LinearProgressIndicator(
                value: s.number('round') / s.number('rounds'),
                color: ReaktColors.accent,
              ),
            const SizedBox(height: 12),
            Text(
              'Nodo objetivo: ${s == null || s.number('target') == 0 ? '—' : s.number('target')}',
            ),
            Text(
              'Peers configurados: ${s?.data['nodes'] ?? '—'} (no indica presencia verificada)',
            ),
            const SizedBox(height: 12),
            const Text(
              'Sin LEDs verificados, estas pruebas comprueban mensajes y pulsador; no miden reacción visual.',
              style: TextStyle(color: ReaktColors.muted),
            ),
            if (s != null)
              ExpansionTile(
                key: const PageStorageKey('gateway-diagnostics'),
                title: const Text('Diagnóstico del gateway'),
                children: [
                  Text(
                    '${s.data['diagnostics'] ?? '—'}\n${s.data['error'] ?? ''}',
                  ),
                ],
              ),
          ],
        ),
      ),
      Metrics({
        'Aciertos': '${s?.data['hits'] ?? '—'}',
        'Fallos': '${s?.data['misses'] ?? '—'}',
        'Anticipadas': '${s?.data['early'] ?? '—'}',
        'Reacción': reaction(s),
      }),
    ];
  }

  List<Widget> _history() => [
    const PageHeading(
      'Historial',
      'Cada sesión, un paso más. Tus capturas se guardan en este teléfono.',
    ),
    Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: busy ? null : () => action(loadHistory),
          icon: const Icon(Icons.refresh),
          label: const Text('Actualizar'),
        ),
        OutlinedButton.icon(
          onPressed: busy ? null : () => action(exportHistory),
          icon: const Icon(Icons.copy),
          label: const Text('Copiar historial JSON'),
        ),
      ],
    ),
    const SizedBox(height: 20),
    if (historyLoading) const Center(child: CircularProgressIndicator()),
    if (!historyLoading && records.isEmpty)
      const Panel(
        child: Text(
          'Todavía no hay sesiones guardadas. Conectá tu gateway y completá tu primer entrenamiento.',
        ),
      ),
    for (final r in records)
      Panel(
        child: ExpansionTile(
          key: PageStorageKey('session-${r.snapshot.id}'),
          tilePadding: EdgeInsets.zero,
          title: Text('Sesión · ${sessionStatus(r.snapshot.status)}'),
          subtitle: Text(
            '${r.date}\n${r.synced ? 'Sincronizada' : 'Guardada localmente'}',
          ),
          children: [
            Metrics({
              'Precisión': precision(r.snapshot),
              'Reacción': reaction(r.snapshot),
              'Aciertos': '${r.snapshot.number('hits')}',
              'Fallos': '${r.snapshot.number('misses')}',
            }),
            const SizedBox(height: 12),
            Text(
              'Anticipadas: ${r.snapshot.number('early')} · Rondas: ${r.snapshot.number('round')}/${r.snapshot.number('rounds')}',
            ),
            Text('Sesión: ${r.snapshot.id}'),
            for (final event in r.snapshot.events)
              ListTile(
                title: Text('Ronda ${event['round']} · Nodo ${event['node']}'),
                subtitle: Text(
                  event['kind'] == 'hit'
                      ? 'Acierto · ${((event['reaction_us'] as int) / 1000).toStringAsFixed(1)} ms'
                      : event['kind'] == 'miss'
                      ? 'Tiempo agotado'
                      : 'Pulsación anticipada',
                ),
              ),
          ],
        ),
      ),
  ];

  List<Widget> _progress() {
    final completed = records
        .where((r) => r.snapshot.status == 'completed')
        .toList();
    final hits = completed.fold<int>(
      0,
      (sum, r) => sum + r.snapshot.number('hits'),
    );
    final misses = completed.fold<int>(
      0,
      (sum, r) => sum + r.snapshot.number('misses'),
    );
    // Weight each capture by actual hit count; do not average session means.
    final totalUs = completed.fold<int>(
      0,
      (sum, r) =>
          sum +
          r.snapshot.events
              .where((e) => e['kind'] == 'hit')
              .fold<int>(0, (n, e) => n + (e['reaction_us'] as int)),
    );
    final days = completed
        .map(
          (r) =>
              '${r.capturedAt.year}-${r.capturedAt.month}-${r.capturedAt.day}',
        )
        .toSet()
        .length;
    return [
      const PageHeading(
        'Tu progreso',
        'Resultados de tus sesiones completadas en este teléfono.',
      ),
      if (historyLoading) const Center(child: CircularProgressIndicator()),
      Metrics({
        'Sesiones': '${completed.length}',
        'Días entrenados': '$days',
        'Precisión': hits + misses == 0
            ? '—'
            : '${(hits * 100 / (hits + misses)).toStringAsFixed(0)}%',
        'Reacción media': hits == 0
            ? '—'
            : '${(totalUs / hits / 1000).toStringAsFixed(1)} ms',
      }),
      const SizedBox(height: 20),
      if (completed.isEmpty)
        const Panel(
          child: Text(
            'Completá una sesión para empezar a ver tu evolución. Las sesiones canceladas o interrumpidas se conservan en Historial.',
          ),
        ),
      if (completed.isNotEmpty)
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Precisión · últimas 10 sesiones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              for (final r in completed.take(10).toList().reversed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.date} · ${precision(r.snapshot)} · ${reaction(r.snapshot)}',
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: r.snapshot.number('rounds') == 0
                            ? 0
                            : r.snapshot.number('hits') /
                                  r.snapshot.number('rounds'),
                        minHeight: 8,
                        color: ReaktColors.accent,
                        backgroundColor: ReaktColors.line,
                      ),
                    ],
                  ),
                ),
              const Text(
                'Precisión = aciertos / (aciertos + fallos). Reacción media ponderada por aciertos. Velocidad y resistencia todavía no se miden.',
                style: TextStyle(color: ReaktColors.muted),
              ),
            ],
          ),
        ),
      ActionCard(
        icon: Icons.bolt,
        title: 'Seguí entrenando',
        subtitle: 'Tu próxima sesión te espera.',
        onTap: () => navigate(1),
      ),
    ];
  }

  List<Widget> _profile() {
    final user = widget.cloud?.auth.currentUser;
    return [
      const PageHeading(
        'Perfil',
        'Tu cuenta y tus datos, también fuera del entrenamiento.',
      ),
      Panel(
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF501219),
              child: Icon(Icons.person, color: ReaktColors.soft),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Atleta REAKT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    user?.email ?? 'Entrenamiento local · sin cuenta',
                    style: const TextStyle(color: ReaktColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ActionCard(
        icon: Icons.wifi,
        title: 'Conectividad',
        subtitle: link.connected
            ? 'Gateway conectada'
            : 'Configurar conexión al gateway',
        onTap: () => navigate(1),
      ),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sincronización Supabase',
              style: TextStyle(fontSize: 20),
            ),
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
                onPressed: busy
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
                onPressed: busy
                    ? null
                    : () => action(() => widget.cloud!.auth.signOut()),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ],
        ),
      ),
      const Text(
        'La conexión a Internet se usa para iniciar sesión y sincronizar. Volvé a una red con Internet después del entrenamiento.',
        style: TextStyle(color: ReaktColors.muted),
      ),
      const SizedBox(height: 16),
      const Text(
        'REAKT · E.E.S.T. N.º 4\nMVP: reflejos y prueba manual. Arquitectura prevista: gateway ESP32 y cinco nodos; el contrato MVP actual admite hasta dos.',
        style: TextStyle(color: ReaktColors.muted),
      ),
    ];
  }
}
