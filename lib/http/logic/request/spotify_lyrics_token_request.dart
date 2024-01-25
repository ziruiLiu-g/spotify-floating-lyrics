import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:spotify_desk_lyric/util/global.dart';
import 'package:spotify_desk_lyric/util/local_storage.dart';

import 'base_request.dart';

class SpotifyLyricsTokenRequest extends BaseRequest {
  SpotifyLyricsTokenRequest() {
    options = Options(
      headers: {
        'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.0.0 Safari/537.36',
        "App-platform": "WebPlayer",
        'cookie':
            'sp_dc=${LocalStorage.getInstance().get("sp_dc")}'
      }
    );

    useForm = true;
    
    add("reason", "transport").add("productType", "web_player");
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  String authority() {
    return 'open.spotify.com';
  }

  @override
  String path() {
    return '/get_access_token?';
  }
}
