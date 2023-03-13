import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../logic/request/base_request.dart';
import 'hi_error.dart';
import 'hi_net_adaptor.dart';


class DioAdaptor extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response;
    var error;

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: request.options);
        // response = await Dio().get("https://accounts.spotify.com/authorize?response_type=code&client_id=946b6d4e6deb44eaa99206097aa271c2&scope=user-read-private user-read-email&state=1234567891011121&redirect_uri=http://localhost:8888/callback");
      } else if (request.httpMethod() == HttpMethod.POST) {
        if (request.useForm) {
          response = await Dio().post(request.url(), data: request.params, options: request.options);
        } else {
           response = await Dio().post(request.url(), data: jsonEncode(request.params), options: request.options);
        }
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      throw HiNetError(response?.statusCode ?? -1, error.toString(), data: await buildRes(response, request));
    }

    return buildRes(response, request);
  }

  Future<HiNetResponse<T>> buildRes<T>(Response? response, BaseRequest request) {
    return Future.value(HiNetResponse(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response));
  }
}
