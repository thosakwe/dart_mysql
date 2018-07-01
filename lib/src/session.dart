part of mysql;

class MySqlSession {
  final Uri uri;
  int _pointer;
  bool _isOpen = true;

  static List _Session_new(String url) native "Session_new";

  MySqlSession(this.uri) {
    if (uri.scheme != 'mysql' && uri.scheme != 'mysqlx') {
      throw new FormatException(
          'Expected a URI with scheme "mysql" or "mysqlx".');
    }
  }

  Future open() {
    if (_pointer != null) return new Future.value();
    var result = _Session_new(uri.toString());

    if (result[0] != null) {
      return new Future.error(
          new MySqlException(result[0] as int, result[1] as String));
    }

    _pointer = result[2] as int;
    return new Future.value();
  }

  void _close(int pointer) native "Session_close";

  Future close() {
    if (_isOpen) {
      _isOpen = false;
      _close(_pointer);
    }

    return new Future.value();
  }
}
