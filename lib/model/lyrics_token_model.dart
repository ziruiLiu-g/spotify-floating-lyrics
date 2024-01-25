class LyricsTokenModel {
  String clientId = '';
  String accessToken = '';
  int accessTokenExpirationTimestampMs = 0;
  bool isAnonymous = false;

  LyricsTokenModel(this.clientId, this.accessToken, this.accessTokenExpirationTimestampMs, this.isAnonymous);
}