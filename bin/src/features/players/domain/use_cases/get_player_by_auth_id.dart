import '../models/player_model.dart';
import '../repositories/players_repository.dart';

class GetPlayerByAuthIdUseCase {
  GetPlayerByAuthIdUseCase({
    required this.playersRepository,
  });

  final PlayersRepository playersRepository;

  Future<PlayerModel?> call({
    required int authId,
  }) async {
    return await playersRepository.getPlayerByAuthId(authId: authId);
  }
}
