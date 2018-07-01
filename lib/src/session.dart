part of mysql;

class MySqlSession {
  final Uri uri;

  final RawReceivePort _recv = new RawReceivePort();
  final Map<int, Completer<List>> _awaiting = <int, Completer<List>>{};
  final Pool _mutex = new Pool(1);
  int _pointer;
  bool _isOpen = true;
  SendPort _sendPort;

  static void _Session_new(int completerHashcode, String url, SendPort sendPort)
      native "Session_new";

  MySqlSession(this.uri) {
    if (uri.scheme != 'mysql' && uri.scheme != 'mysqlx') {
      throw new FormatException(
          'Expected a URI with scheme "mysql" or "mysqlx".');
    }

    _recv.handler = _onMessage;
  }

  void _onMessage(x) {
    if (x is List && x.length >= 2) {
      var completerHashcode = x[0];

      if (completerHashcode is int) {
        _mutex
            .withResource(() => _awaiting.remove(completerHashcode))
            .then((completer) {
          completer?.complete(x.skip(1).toList());
        });
      }
    }
  }

  Future open() {
    if (_pointer != null) return new Future.value();
    var c = new Completer<List>();

    return _mutex.withResource(() => _awaiting[c.hashCode] = c).then((_) {
      _Session_new(c.hashCode, uri.toString(), _recv.sendPort);
      return c.future.then((result) {
        if (result[0] != null) {
          return new Future.error(
              new MySqlException(result[0] as int, result[1] as String));
        }

        _pointer = result[2] as int;
        _sendPort = result[3] as SendPort;
      });
    });
  }

  static void _close(int pointer) native "Session_close";

  Future close() {
    if (_isOpen) {
      _isOpen = false;
      _close(_pointer);
    }

    return new Future.value();
  }
}
