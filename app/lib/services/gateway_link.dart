import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'local_store.dart';
import 'snapshot.dart';

class GatewayLink extends ChangeNotifier {
  final LocalStore store;
  GatewayLink(this.store);
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _retry, _watchdog;
  bool _wanted = false, connected = false, _disposed = false;
  int _generation = 0, _attempt = 0;
  bool _storageFailed = false;
  String address = 'ws://192.168.4.1:81', error = '';
  TrainingSnapshot? snapshot;
  DateTime? _lastMessage;
  Future<void> _writes = Future<void>.value();
  Future<void> flush() => _writes;
  Future<void> connect(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !{'ws', 'wss'}.contains(uri.scheme) ||
        !uri.hasAuthority ||
        uri.userInfo.isNotEmpty) {
      error = 'Dirección WebSocket inválida';
      notifyListeners();
      return;
    }
    disconnect();
    address = value;
    _wanted = true;
    _attempt = 0;
    await _open();
  }

  Future<void> _open() async {
    if (!_wanted || _disposed) return;
    final generation = ++_generation;
    try {
      final channel = WebSocketChannel.connect(Uri.parse(address));
      _channel = channel;
      await channel.ready.timeout(const Duration(seconds: 6));
      if (generation != _generation || !_wanted) {
        await channel.sink.close();
        return;
      }
      connected = false;
      error = 'Esperando snapshot válido';
      _lastMessage = DateTime.now();
      notifyListeners();
      _subscription = channel.stream.listen(
        (raw) {
          if (generation != _generation) return;
          try {
            if (raw is! String || raw.length > 32768)
              throw const FormatException('Mensaje inválido');
            final data = jsonDecode(raw);
            if (data is Map && data['type'] == 'error') {
              error = '${data['error']}';
              notifyListeners();
              return;
            }
            final next = TrainingSnapshot.parse(data);
            _lastMessage = DateTime.now();
            snapshot = next;
            connected = true;
            _attempt = 0;
            error = '';
            _writes = _writes
                .then((_) async {
                  await store.save(next);
                  _storageFailed = false;
                })
                .catchError((Object e) {
                  _storageFailed = true;
                  if (!_disposed) {
                    error = 'No se pudo guardar localmente: $e';
                    notifyListeners();
                  }
                });
            notifyListeners();
          } catch (e) {
            error = 'Respuesta rechazada: $e';
            notifyListeners();
          }
        },
        onDone: () => _lost(generation, 'Gateway desconectada'),
        onError: (Object e) => _lost(generation, '$e'),
      );
      _watchdog?.cancel();
      _watchdog = Timer.periodic(const Duration(seconds: 2), (_) {
        if (_lastMessage != null &&
            DateTime.now().difference(_lastMessage!).inSeconds > 6) {
          _lost(generation, 'Sin snapshots de la gateway');
        }
      });
    } catch (e) {
      _lost(generation, '$e');
    }
  }

  void _lost(int generation, String reason) {
    if (generation != _generation || !_wanted || _disposed) return;
    ++_generation;
    connected = false;
    error = reason;
    _watchdog?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    notifyListeners();
    final seconds = 1 << (_attempt < 4 ? _attempt++ : 4);
    _retry?.cancel();
    _retry = Timer(Duration(seconds: seconds), _open);
  }

  Future<void> command(
    String name, {
    int rounds = 10,
    int limitMs = 1500,
  }) async {
    if (!connected || _channel == null)
      throw StateError('Gateway sin conexión');
    final channel = _channel!;
    final generation = _generation;
    // A stop remains available even if SQLite is unavailable.
    if (name != 'stop') {
      await flush();
      if (_storageFailed)
        throw StateError(
          'Almacenamiento local no disponible; no iniciar otra sesión',
        );
    }
    if (!connected || generation != _generation || channel != _channel) {
      throw StateError(
        'La conexión cambió; revisá el estado antes de enviar la orden',
      );
    }
    channel.sink.add(
      jsonEncode({
        'v': 1,
        'id': '${DateTime.now().microsecondsSinceEpoch}',
        'command': name,
        'rounds': rounds,
        'limit_ms': limitMs,
      }),
    );
  }

  void disconnect() {
    _wanted = false;
    ++_generation;
    connected = false;
    _retry?.cancel();
    _watchdog?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    disconnect();
    super.dispose();
  }
}
