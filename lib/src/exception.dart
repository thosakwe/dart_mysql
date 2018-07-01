part of mysql;

class MySqlException implements Exception {
  final int errorCode;
  final String message;

  MySqlException(this.errorCode, this.message);

  @override
  String toString() {
    return 'MySQL exception (error code $errorCode): $message';
  }
}
