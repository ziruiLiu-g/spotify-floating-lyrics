import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:spotify_desk_lyric/http/logic/request/spotify_token_request.dart';
import 'package:spotify_desk_lyric/model/token_model.dart';
import 'package:spotify_desk_lyric/util/global.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../core/hi_net.dart';
import '../request/base_request.dart';
import '../request/spotify_login_request.dart';

class LoginDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static var token = "";

  static login() async {
    _logger.d(Global.clientId);

    BaseRequest request;
    request = SpotifyLoginRequest();

    final url = request.url();

    // Windows needs some callback URL on localhost
    final callbackUrlScheme = (Platform.isWindows || Platform.isLinux)
        ? 'http://localhost:8888/'
        : 'foobar';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
        // If needed: preferEphemeral: true,
      );
      token = Uri.parse(result).queryParameters['code']!;
    } on PlatformException catch (e) {
      _logger.d(e);
    }
  }

  static getToken() async {
    BaseRequest request;
    request = SpotifyTokenRequest();

    request
      .addParams("code", token)
      .addParams("grant_type", "authorization_code")
      .addParams("redirect_uri", "http://localhost:8888/");

    try {
      var result = await HiNet.getInstace().fire(request);

      Global.tokenInstance = TokenModel(
          result['access_token'],
          result['token_type'],
          result['expires_in'],
          result['refresh_token'],
          result['scope']
      );
    } on Exception {
      await refreshToken();
    }

    _logger.d(Global.tokenInstance.accessToken);
  }

  static refreshToken() async {
    BaseRequest request;
    request = SpotifyTokenRequest();

    request
      .addParams("code", token)
      .addParams("grant_type", "refresh_token")
      .addParams("refresh_token", Global.tokenInstance.refreshToken);

    var result = await HiNet.getInstace().fire(request);

    Global.tokenInstance = TokenModel(
        result['access_token'],
        result['token_type'],
        result['expires_in'],
        result['refresh_token'],
        result['scope']
    );
  }
}
