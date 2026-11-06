part of '../main.dart';

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
    theme: _crearTemaReakt(),
    home: TrainingPage(store: store, cloud: cloud, cloudError: cloudError),
  );
}
