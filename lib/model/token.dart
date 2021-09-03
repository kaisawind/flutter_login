class Token {
  String accessToken;
  String tokenType;
  String expiresIn;
  String expiresAt;

  Token({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(accessToken: json['access_token'], tokenType: json['token_type'], expiresIn: json['expires_in'], expiresAt: json['expires_at']);
  }
}
