import 'package:dio/dio.dart';

import '../../../util/global.dart';
import 'base_request.dart';

class SpotifyHeroKuAppRequest extends BaseRequest {
  var trackId = "";

  SpotifyHeroKuAppRequest() {
    options = Options(responseType: ResponseType.json, headers: {
      'user-agent':
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.0.0 Safari/537.36',
      "App-platform": "WebPlayer",
      'authorization': 'Bearer ${Global.lyricsTokenModel.accessToken}'
    });
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  String authority() {
    return 'spclient.wg.spotify.com';
  }

  @override
  String path() {
    return "/color-lyrics/v2/track/${trackId}?";
  }
}
