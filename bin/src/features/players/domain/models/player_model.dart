import 'package:equatable/equatable.dart';

class PlayerModel extends Equatable {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.nickname,
  });

  final int id;
  final String name;
  final String nickname;

  @override
  List<Object?> get props => [
        id,
        name,
        nickname,
      ];
}
