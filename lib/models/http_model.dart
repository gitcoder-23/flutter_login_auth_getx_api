class AppHttpResponse {
  int code;
  String message;

  Object? data;

  AppHttpResponse({required this.code, required this.message, this.data});
}
