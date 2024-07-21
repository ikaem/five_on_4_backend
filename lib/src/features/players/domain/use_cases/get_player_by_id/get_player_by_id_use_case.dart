import '../../models/player_model.dart';
import '../../repositories/players_repository.dart';

class GetPlayerByIdUseCase {
  GetPlayerByIdUseCase({
    required PlayersRepository playersRepository,
  }) : _playersRepository = playersRepository;

  final PlayersRepository _playersRepository;

  Future<PlayerModel?> call({required int id}) async {
    return _playersRepository.getPlayerById(id: id);
  }
}
