import '../models/player_model.dart';

abstract interface class PlayersRepository {
  Future<PlayerModel?> getPlayerByAuthId({
    required int authId,
  });
}
