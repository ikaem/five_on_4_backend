import 'package:equatable/equatable.dart';

class PlayerModel extends Equatable {
  const PlayerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.authId,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String nickname;
  final int authId;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        nickname,
        authId,
      ];
}
