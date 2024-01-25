import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:spotify_desk_lyric/http/logic/request/spotify_token_request.dart';
import 'package:spotify_desk_lyric/model/lyrics_token_model.dart';
import 'package:spotify_desk_lyric/model/token_model.dart';
import 'package:spotify_desk_lyric/util/global.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../util/local_storage.dart';
import '../../core/hi_net.dart';
import '../request/base_request.dart';
import '../request/spotify_login_request.dart';
import '../request/spotify_lyrics_token_request.dart';

class LyricsTokenDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static var token = "";

  static getToken() async {
    BaseRequest request;
    request = SpotifyLyricsTokenRequest();

    var result = await HiNet.getInstace().fire(request);

    Global.lyricsTokenModel = LyricsTokenModel(
        result['clientId'],
        result['accessToken'],
        result['accessTokenExpirationTimestampMs'],
        result['isAnonymous']
    );
  }
}
