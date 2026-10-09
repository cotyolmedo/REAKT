import 'package:flutter/material.dart';

void main() => runApp(const ReaktApp());

abstract final class ReaktColors {
  static const background = Color(0xFF070707);
  static const card = Color(0xFF121214);
  static const raised = Color(0xFF18181B);
  static const line = Color(0xFF2B2B30);
  static const muted = Color(0xFFA1A1AA);
  static const accent = Color(0xFFE3262E);
  static const accentSoft = Color(0xFFFF4B52);
}

class ReaktApp extends StatelessWidget {
  const ReaktApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'REAKT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ReaktColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: ReaktColors.accent, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      );
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: IndexedStack(index: tab, children: const [HomeView(), TrainingView(), ProgressView(), ProfileView()]),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          backgroundColor: ReaktColors.raised,
          indicatorColor: ReaktColors.accent.withValues(alpha: .18),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.bolt_rounded), label: 'Entrenar'),
            NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Progreso'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
          ],
        ),
      );
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          const TopBar(),
          const SizedBox(height: 30),
          const Text('TU PRÓXIMO NIVEL', style: TextStyle(color: ReaktColors.accentSoft, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.6)),
          const SizedBox(height: 8),
          Text('Entrená\ncon intención.', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: .98)),
          const SizedBox(height: 14),
          const Text('Medí tus respuestas, entendé tu rendimiento y convertí cada sesión en progreso.', style: TextStyle(color: ReaktColors.muted, height: 1.5, fontSize: 15)),
          const SizedBox(height: 24),
          FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Comenzar entrenamiento'), style: FilledButton.styleFrom(backgroundColor: ReaktColors.accent, minimumSize: const Size.fromHeight(52), shape: const StadiumBorder(), textStyle: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(height: 28),
          const SectionTitle(title: 'Resumen de rendimiento', action: 'Esta semana'),
          const SizedBox(height: 12),
          const Row(children: [Expanded(child: MetricCard(value: '86%', label: 'Precisión', icon: Icons.track_changes_rounded)), SizedBox(width: 12), Expanded(child: MetricCard(value: '0.42s', label: 'Reacción', icon: Icons.timer_outlined))]),
          const SizedBox(height: 12),
          const Surface(child: Row(children: [Icon(Icons.bolt_rounded, color: ReaktColors.accentSoft, size: 30), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Última sesión', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('Reflejos · 12 min · 48 respuestas', style: TextStyle(color: ReaktColors.muted, fontSize: 12))])), Icon(Icons.chevron_right_rounded, color: ReaktColors.muted)])),
        ],
      );
}

class TrainingView extends StatelessWidget {
  const TrainingView({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Entrenamientos', subtitle: 'Elegí un modo y prepará tu próxima sesión.', child: const Column(children: [ModeTile(name: 'Reflejos', description: 'Responder al estímulo.', icon: Icons.flash_on_rounded), ModeTile(name: 'Velocidad', description: 'Ejecutar en el menor tiempo.', icon: Icons.speed_rounded), ModeTile(name: 'Precisión', description: 'Acertar el objetivo.', icon: Icons.gps_fixed_rounded), ModeTile(name: 'Coordinación', description: 'Sincronizar respuesta y movimiento.', icon: Icons.hub_rounded)]));
}

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Tu progreso', subtitle: 'Una mirada clara a cómo estás evolucionando.', child: const Column(children: [Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Rendimiento general', style: TextStyle(color: ReaktColors.muted, fontSize: 12)), SizedBox(height: 10), Text('+12.4%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32)), SizedBox(height: 12), LinearProgressIndicator(value: .72, minHeight: 8, color: ReaktColors.accent, backgroundColor: ReaktColors.line), SizedBox(height: 10), Text('Comparado con tus últimas 10 sesiones', style: TextStyle(color: ReaktColors.muted, fontSize: 12))])), SizedBox(height: 18), SectionTitle(title: 'Últimas sesiones', action: 'Ver historial'), SizedBox(height: 12), HistoryTile(date: 'Hoy, 18:42', mode: 'Reflejos', score: '86%'), HistoryTile(date: 'Ayer, 19:10', mode: 'Velocidad', score: '78%')]));
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Perfil', subtitle: 'Configurá tu experiencia REAKT.', child: const Column(children: [Surface(child: Row(children: [CircleAvatar(radius: 28, backgroundColor: ReaktColors.raised, child: Icon(Icons.person_outline_rounded, color: ReaktColors.accentSoft)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Atleta REAKT', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('Configuración inicial pendiente', style: TextStyle(color: ReaktColors.muted, fontSize: 12))])])), SizedBox(height: 16), SettingTile(title: 'Conectividad', detail: 'Gateway no configurado', icon: Icons.wifi_off_rounded), SettingTile(title: 'Preferencias', detail: 'Notificaciones y objetivos', icon: Icons.tune_rounded), SettingTile(title: 'Documentación', detail: 'Arquitectura y estado del proyecto', icon: Icons.menu_book_outlined)]));
}

class SimplePage extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const SimplePage({required this.title, required this.subtitle, required this.child, super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 28), children: [const TopBar(), const SizedBox(height: 32), Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(subtitle, style: const TextStyle(color: ReaktColors.muted, height: 1.5)), const SizedBox(height: 24), child]);
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 38, height: 38, alignment: Alignment.center, decoration: BoxDecoration(color: ReaktColors.accent, borderRadius: BorderRadius.circular(12)), child: const Text('R', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20))), const SizedBox(width: 10), const Text('REAKT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)), const Spacer(), const Icon(Icons.notifications_none_rounded, color: Colors.white70)]);
}

class SectionTitle extends StatelessWidget { final String title, action; const SectionTitle({required this.title, required this.action, super.key}); @override Widget build(BuildContext context) => Row(children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), const Spacer(), Text(action, style: const TextStyle(color: ReaktColors.accentSoft, fontSize: 12, fontWeight: FontWeight.w700))]); }
class Surface extends StatelessWidget { final Widget child; const Surface({required this.child, super.key}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: ReaktColors.card, border: Border.all(color: ReaktColors.line), borderRadius: BorderRadius.circular(20)), child: child); }
class MetricCard extends StatelessWidget { final String value, label; final IconData icon; const MetricCard({required this.value, required this.label, required this.icon, super.key}); @override Widget build(BuildContext context) => Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: ReaktColors.accentSoft), const SizedBox(height: 18), Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 26)), const SizedBox(height: 3), Text(label, style: const TextStyle(color: ReaktColors.muted, fontSize: 12))])); }
class ModeTile extends StatelessWidget { final String name, description; final IconData icon; const ModeTile({required this.name, required this.description, required this.icon, super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Surface(child: Row(children: [Icon(icon, color: ReaktColors.accentSoft), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(description, style: const TextStyle(color: ReaktColors.muted, fontSize: 12))])), const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: ReaktColors.muted)]))); }
class HistoryTile extends StatelessWidget { final String date, mode, score; const HistoryTile({required this.date, required this.mode, required this.score, super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Surface(child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(mode, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(date, style: const TextStyle(color: ReaktColors.muted, fontSize: 12))]), Text(score, style: const TextStyle(color: ReaktColors.accentSoft, fontWeight: FontWeight.w800))]))); }
class SettingTile extends StatelessWidget { final String title, detail; final IconData icon; const SettingTile({required this.title, required this.detail, required this.icon, super.key}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Surface(child: Row(children: [Icon(icon, color: ReaktColors.accentSoft), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(detail, style: const TextStyle(color: ReaktColors.muted, fontSize: 12))]), const Icon(Icons.chevron_right_rounded, color: ReaktColors.muted)]))); }
