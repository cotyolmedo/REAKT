class TrainingSnapshot {
  final Map<String, dynamic> data;
  TrainingSnapshot._(this.data);
  static final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );
  static const terminal = {'completed', 'cancelled', 'interrupted'};
  String get id => data['session_id'] as String;
  String get status => data['status'] as String;
  bool get finished => terminal.contains(status);
  List<Map<String, dynamic>> get events =>
      (data['events'] as List).cast<Map<String, dynamic>>();
  int number(String key) => data[key] as int;
  static TrainingSnapshot parse(dynamic raw) {
    if (raw is! Map<String, dynamic> ||
        raw['v'] != 1 ||
        raw['type'] != 'snapshot') {
      throw const FormatException('Snapshot incompatible');
    }
    final id = raw['session_id'];
    final status = raw['status'];
    if (id is! String ||
        (id.isNotEmpty && !_uuid.hasMatch(id)) ||
        !{'idle', 'running', 'manual', ...terminal}.contains(status) ||
        (id.isEmpty != (status == 'idle')) ||
        raw['active'] is! bool ||
        raw['active'] != (status == 'running' || status == 'manual')) {
      throw const FormatException('Identidad o estado inválido');
    }
    for (final key in [
      'round',
      'rounds',
      'limit_ms',
      'target',
      'hits',
      'misses',
      'early',
      'mean_us',
    ]) {
      if (raw[key] is! int || (raw[key] as int) < 0)
        throw FormatException('Campo inválido: $key');
    }
    if (raw['rounds'] > 50 ||
        raw['round'] > raw['rounds'] ||
        raw['target'] > 2 ||
        (id.isNotEmpty && (raw['limit_ms'] < 100 || raw['limit_ms'] > 10000))) {
      throw const FormatException('Configuración fuera de rango');
    }
    if (raw['events'] is! List || (raw['events'] as List).length > 64) {
      throw const FormatException('Eventos inválidos');
    }
    final ids = <String>{};
    int hits = 0, misses = 0, early = 0, sum = 0;
    for (final event in raw['events'] as List) {
      if (event is! Map<String, dynamic> ||
          event['id'] is! String ||
          !(event['id'] as String).startsWith('$id:') ||
          !ids.add(event['id']) ||
          !{'hit', 'miss', 'early'}.contains(event['kind']) ||
          event['round'] is! int ||
          event['round'] < 1 ||
          event['round'] > raw['round'] ||
          event['node'] is! int ||
          event['node'] < 1 ||
          event['node'] > 2 ||
          event['reaction_us'] is! int ||
          event['reaction_us'] < 0 ||
          (event['kind'] == 'hit' &&
              (event['reaction_us'] == 0 ||
                  event['reaction_us'] >= raw['limit_ms'] * 1000)) ||
          (event['kind'] != 'hit' && event['reaction_us'] != 0)) {
        throw const FormatException('Evento fuera de contrato');
      }
      if (event['kind'] == 'hit') {
        hits++;
        sum += event['reaction_us'] as int;
      }
      if (event['kind'] == 'miss') misses++;
      if (event['kind'] == 'early') early++;
    }
    if (raw['hits'] != hits ||
        raw['misses'] != misses ||
        raw['early'] != early ||
        hits + misses > raw['round'] ||
        (status == 'completed' && hits + misses != raw['rounds']) ||
        raw['mean_us'] != (hits == 0 ? 0 : sum ~/ hits)) {
      throw const FormatException('Métricas inconsistentes');
    }
    return TrainingSnapshot._(Map<String, dynamic>.from(raw));
  }
}
