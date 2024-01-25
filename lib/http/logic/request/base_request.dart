import 'package:dio/dio.dart';
import 'package:http/http.dart';

enum HttpMethod { GET, POST, DELETE }

// basic requests
abstract class BaseRequest {
  var options = Options();
  Map<String, dynamic> pathParams = Map();
  Map<String, dynamic> params = Map();

  var useHttps = true;

  var useForm = false;

  var apiPath = "";

  String authority() {
    return "";
  }
  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = path();

    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}";
      } else if (path().endsWith("?")) {
        pathStr = "${path()}${pathParamStringify()}";
      } else {
        pathStr = "${path()}";
      }
    }

    // http and https switcher
    if (useHttps) {
      uri = Uri.https(authority(), pathStr);
    } else {
      uri = Uri.http(authority(), pathStr);
    }
    return uri.toString().replaceAll("%3F", "?");
  }

  BaseRequest add(String k, Object v) {
    pathParams[k] = v;
    return this;
  }

  BaseRequest addParams(String k, Object v) {
    params[k] = v;
    return this;
  }

  BaseRequest addHeader(String k, Object v) {
    return this;
  }

  String pathParamStringify() {
    var plist = [];
    pathParams.entries.forEach((e) => plist.add('${e.key}=${e.value}'));

    return plist.join("&");
  }
}
