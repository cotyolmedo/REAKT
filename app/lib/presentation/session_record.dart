import 'dart:convert';
import '../services/snapshot.dart';

/// A validated local capture, separate from its storage representation.
class SessionRecord {
  final TrainingSnapshot snapshot;
  final DateTime capturedAt;
  final bool synced;
  SessionRecord(this.snapshot, this.capturedAt, this.synced);

  factory SessionRecord.fromRow(Map<String, Object?> row) => SessionRecord(
    TrainingSnapshot.parse(jsonDecode(row['payload'] as String)),
    DateTime.parse(row['captured_at'] as String).toLocal(),
    row['synced'] == 1,
  );

  String get date =>
      '${capturedAt.day.toString().padLeft(2, '0')}/'
      '${capturedAt.month.toString().padLeft(2, '0')}/${capturedAt.year} · '
      '${capturedAt.hour.toString().padLeft(2, '0')}:'
      '${capturedAt.minute.toString().padLeft(2, '0')}';
}

String precision(TrainingSnapshot? s) {
  if (s == null) return '—';
  final total = s.number('hits') + s.number('misses');
  return total == 0
      ? '—'
      : '${(s.number('hits') * 100 / total).toStringAsFixed(0)}%';
}

String reaction(TrainingSnapshot? s) => s == null || s.number('hits') == 0
    ? '—'
    : '${(s.number('mean_us') / 1000).toStringAsFixed(1)} ms';

String sessionStatus(String status) =>
    const {
      'idle': 'En espera',
      'running': 'En curso',
      'manual': 'Prueba manual',
      'completed': 'Completada',
      'cancelled': 'Cancelada',
      'interrupted': 'Interrumpida',
    }[status] ??
    status;
