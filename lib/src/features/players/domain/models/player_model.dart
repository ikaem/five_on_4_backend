import 'package:equatable/equatable.dart';

class PlayerModel extends Equatable {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.authId,
  });

  final int id;
  final String name;
  final String nickname;
  final int authId;

  @override
  List<Object?> get props => [
        id,
        name,
        nickname,
        authId,
      ];
}
