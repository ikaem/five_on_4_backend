import 'package:equatable/equatable.dart';

abstract interface class PlayerMatchParticipationsDataSource {
  Future<int> createParticipation({
    required CreatePlayerMatchParticipationValue value,
  });
}

// TODO not needed yet
// TODO move to values later
class PlayerMatchParticipationEntityValue extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CreatePlayerMatchParticipationValue {
  CreatePlayerMatchParticipationValue({
    required this.playerId,
    required this.matchId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int playerId;
  final int matchId;
  // TODO this could possibly have a default value
  final int createdAt;
  final int updatedAt;
}
