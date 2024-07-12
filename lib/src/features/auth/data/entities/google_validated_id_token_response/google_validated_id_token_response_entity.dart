import 'package:equatable/equatable.dart';

class GoogleApisValidatedIdTokenResponseEntity extends Equatable {
  const GoogleApisValidatedIdTokenResponseEntity({
    required this.iss,
    required this.azp,
    required this.aud,
    required this.sub,
    required this.email,
    required this.emailVerified,
    required this.name,
    required this.picture,
    required this.givenName,
    required this.familyName,
    required this.iat,
    required this.exp,
    required this.alg,
    required this.kid,
    required this.typ,
  });

  final String iss;
  final String azp;
  final String aud;
  final String sub;
  final String email;
  final bool emailVerified;
  final String name;
  final String picture;
  final String givenName;
  final String familyName;
  final int iat;
  final int exp;
  final String alg;
  final String kid;
  final String typ;

  @override
  List<Object?> get props => [
        iss,
        azp,
        aud,
        sub,
        email,
        emailVerified,
        name,
        picture,
        givenName,
        familyName,
        iat,
        exp,
        alg,
        kid,
        typ,
      ];

  GoogleApisValidatedIdTokenResponseEntity.fromJson({
    required Map<String, dynamic> json,
  })  : iss = json['iss'] as String,
        azp = json['azp'] as String,
        aud = json['aud'] as String,
        sub = json['sub'] as String,
        email = json['email'] as String,
        emailVerified = (json['email_verified'] as String) == 'true',
        name = json['name'] as String,
        picture = json['picture'] as String,
        givenName = json['given_name'] as String,
        familyName = json['family_name'] as String,
        iat = int.tryParse(json['iat'] as String) ?? 0,
        exp = int.tryParse(json['exp'] as String) ?? 0,
        alg = json['alg'] as String,
        kid = json['kid'] as String,
        typ = json['typ'] as String;
}
