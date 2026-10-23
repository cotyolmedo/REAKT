import 'package:flutter/material.dart';

abstract final class ReaktColors {
  static const background = Color(0xFF100707);
  static const card = Color(0xFF121212);
  static const line = Color(0xFF2A2424);
  static const muted = Color(0xFFB5ABAB);
  static const accent = Color(0xFFCF1821);
  static const soft = Color(0xFFFF7379);
}

class Panel extends StatelessWidget {
  final Widget child;
  const Panel({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    child: Material(
      color: ReaktColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: ReaktColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  );
}

class PageHeading extends StatelessWidget {
  final String title, subtitle;
  const PageHeading(this.title, this.subtitle, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: ReaktColors.muted, height: 1.5),
        ),
      ],
    ),
  );
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: ReaktColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ReaktColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ReaktColors.accent.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: ReaktColors.soft),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: ReaktColors.muted),
        ),
        trailing: const Icon(Icons.chevron_right, color: ReaktColors.soft),
        onTap: onTap,
      ),
    ),
  );
}

class Metrics extends StatelessWidget {
  final Map<String, String> values;
  const Metrics(this.values, {super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth < 500 ? 2 : 4;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: values.entries
            .map(
              (e) => SizedBox(
                width: (constraints.maxWidth - 12 * (columns - 1)) / columns,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ReaktColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ReaktColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.key,
                        style: const TextStyle(color: ReaktColors.muted),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    },
  );
}
