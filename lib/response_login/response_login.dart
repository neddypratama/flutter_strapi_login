import 'user.dart';

class ResponseLogin {
  String? jwt;
  User? user;

  ResponseLogin({this.jwt, this.user});

  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
        jwt: json['jwt'] as String?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'jwt': jwt,
        'user': user?.toJson(),
      };
}
