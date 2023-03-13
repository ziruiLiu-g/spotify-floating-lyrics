import '../logic/request/base_request.dart';
import 'dio_adaptor.dart';
import 'hi_error.dart';
import 'hi_net_adaptor.dart';

class HiNet {
  HiNet._();

  static HiNet? _instance;

  static HiNet getInstace() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      // other exceptions
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog("no response");
    }

    var result = response?.data;

    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    HiNetAdapter adapter = DioAdaptor() as HiNetAdapter;

    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net: ${log.toString()}');
  }
}
