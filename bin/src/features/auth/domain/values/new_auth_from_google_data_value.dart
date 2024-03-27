import 'package:equatable/equatable.dart';

class NewAuthFromGoogleDataValue extends Equatable {
  const NewAuthFromGoogleDataValue({
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
  });

  final String firstName;
  final String lastName;
  final String nickname;
  final DateTime createdAt;
  final DateTime updatedAt;
  //
  final String email;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        nickname,
        createdAt,
        updatedAt,
        email,
      ];
}


// TODO not needed at all