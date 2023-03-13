import 'package:dio/dio.dart';

import '../../../util/global.dart';
import 'base_request.dart';

class SpotifyPlayerRequest extends BaseRequest {
  SpotifyPlayerRequest() {
    options = Options(
        responseType: ResponseType.json,
        headers: {
        'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
        "Keep-Alive": "timeout=8",
        'Content-Type': 'application/json',
        'Accept': 'application/json',
          'Authorization':
        '${Global.tokenInstance.tokenType} ${Global.tokenInstance.accessToken}'
        }
    );
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  String authority() {
    return 'api.spotify.com';
  }

  @override
  String path() {
    return '/v1/me/player/currently-playing';
  }
}
