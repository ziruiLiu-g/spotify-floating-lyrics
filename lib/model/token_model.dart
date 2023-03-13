class TokenModel {
  String accessToken = '';
  String tokenType = '';
  int expiresIn = 0;
  String refreshToken = '';
  String scope = '';

  TokenModel(this.accessToken, this.tokenType, this.expiresIn, this.refreshToken, this.scope);
}