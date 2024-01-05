import 'package:dio/dio.dart';

import '../../../util/global.dart';
import 'base_request.dart';

class SpotifyHeroKuAppRequest extends BaseRequest {
  SpotifyHeroKuAppRequest() {
    options = Options(
        responseType: ResponseType.json,
        headers: {
        'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
        "Keep-Alive": "timeout=8",
        'Content-Type': 'application/json',
        'Accept': 'application/json'
        }
    );
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  String authority() {
    return 'spotify-lyric-api-984e7b4face0.herokuapp.com';
  }

  @override
  String path() {
    return "/?";
  }
}
