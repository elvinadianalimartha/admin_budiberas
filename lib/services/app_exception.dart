class AppException implements Exception {
  final _message;

  AppException([this._message]);

  @override
  String toString() {
    return "$_message";
  }
}