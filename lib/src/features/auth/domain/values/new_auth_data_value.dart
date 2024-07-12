import 'package:equatable/equatable.dart';

import '../../utils/constants/auth_type_constants.dart';

sealed class NewAuthDataValue extends Equatable {
  const NewAuthDataValue({
    required this.email,
    required this.hashedPassword,
    required this.authType,
    // required this.createdAt,
    // required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.nickname,
  });

  final String email;
  final String? hashedPassword;
  final AuthTypeConstants authType;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  //
  final String firstName;
  final String lastName;
  final String nickname;

  @override
  List<Object?> get props => [
        email,
        hashedPassword,
        authType,
        // createdAt,
        // updatedAt,
        firstName,
        lastName,
        nickname,
      ];
}

class NewAuthDataValueEmailPassword extends NewAuthDataValue {
  const NewAuthDataValueEmailPassword({
    required super.email,
    required String super.hashedPassword,
    // required super.authType,
    // required super.createdAt,
    // required super.updatedAt,
    required super.firstName,
    required super.lastName,
    required super.nickname,
  }) : super(
          authType: AuthTypeConstants.emailPassword,
        );
}

class NewAuthDataValueGoogle extends NewAuthDataValue {
  const NewAuthDataValueGoogle({
    required super.email,
    // required super.createdAt,
    // required super.updatedAt,
    required super.firstName,
    required super.lastName,
    required super.nickname,
  }) : super(
          hashedPassword: null,
          authType: AuthTypeConstants.google,
        );
}
