class NeedLogin extends HiNetError {
  NeedLogin({int code: 401, String message: 'Please Login..'}) : super(code, message);
}

class NeedAuth extends HiNetError {
  NeedAuth(String message, {int code: 403, dynamic data}) : super(code, message, data: data);
}

class HiNetError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  HiNetError(this.code, this.message, {this.data});
}
