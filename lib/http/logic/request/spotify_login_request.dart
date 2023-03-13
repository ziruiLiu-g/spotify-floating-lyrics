import 'base_request.dart';

class SpotifyLoginRequest extends BaseRequest {
  SpotifyLoginRequest() {
    var scope = 'user-read-private '
        'user-read-email '
        'user-read-playback-position '
        'user-library-read '
        'user-library-modify '
        'playlist-modify-public '
        'playlist-modify-private '
        'playlist-read-private '
        'user-top-read '
        'playlist-read-collaborative '
        'ugc-image-upload '
        'user-follow-read '
        'user-follow-modify '
        'user-read-playback-state '
        'user-modify-playback-state '
        'user-read-currently-playing '
        'user-read-recently-played';

    add("response_type", "code")
      .add("client_id", "946b6d4e6deb44eaa99206097aa271c2")
      .add("scope", scope)
      .add("state", "1234567891011124")
      .add("redirect_uri", 'http://localhost:8888/');
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  String authority() {
    return 'accounts.spotify.com';
  }

  @override
  String path() {
    return '/authorize?';
  }
}
