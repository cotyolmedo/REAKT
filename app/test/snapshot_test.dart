import 'package:flutter_test/flutter_test.dart';
import 'package:reakt_app/services/snapshot.dart';

Map<String, dynamic> fixture() => {
  'v': 1,
  'type': 'snapshot',
  'session_id': '12345678-1234-4567-8123-123456789abc',
  'active': false,
  'status': 'completed',
  'round': 1,
  'rounds': 1,
  'limit_ms': 1500,
  'target': 1,
  'hits': 1,
  'misses': 0,
  'early': 0,
  'mean_us': 250000,
  'events': [
    {
      'id': '12345678-1234-4567-8123-123456789abc:1',
      'round': 1,
      'node': 1,
      'kind': 'hit',
      'reaction_us': 250000,
    },
  ],
};
void main() {
  test('accepts completed snapshot and measured reaction', () {
    final s = TrainingSnapshot.parse(fixture());
    expect(s.finished, true);
    expect(s.events.single['reaction_us'], 250000);
  });
  test('rejects inconsistent metrics', () {
    final data = fixture()..['hits'] = 2;
    expect(() => TrainingSnapshot.parse(data), throwsFormatException);
  });
  test('rejects duplicates', () {
    final data = fixture();
    (data['events'] as List).add((data['events'] as List).first);
    expect(() => TrainingSnapshot.parse(data), throwsFormatException);
  });
  test('rejects out of window reaction', () {
    final data = fixture();
    (data['events'] as List).first['reaction_us'] = 1500000;
    expect(() => TrainingSnapshot.parse(data), throwsFormatException);
  });
  test('rejects future wire version', () {
    expect(
      () => TrainingSnapshot.parse(fixture()..['v'] = 2),
      throwsFormatException,
    );
  });
}
