import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:spotify_desk_lyric/util/global.dart';

import 'base_request.dart';

class SpotifyTokenRequest extends BaseRequest {
  SpotifyTokenRequest() {
    options = Options(
      contentType: "application/x-www-form-urlencoded",
      responseType: ResponseType.json,
      headers: {
        'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
            'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
        "Keep-Alive": "timeout=8",
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('${Global.clientId}:${Global.clientSecret}'))}'
      }
    );

    useForm = true;
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  String authority() {
    return 'accounts.spotify.com';
  }

  @override
  String path() {
    return '/api/token';
  }
}
