import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/repositories/players_repository.dart';
import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';

class SearchPlayersUseCase {
  const SearchPlayersUseCase({
    required PlayersRepository playersRepository,
  }) : _playersRepository = playersRepository;

  final PlayersRepository _playersRepository;

  Future<List<PlayerModel>> call({
    required PlayersSearchFilterValue filter,
  }) async {
    return _playersRepository.searchPlayers(filter: filter);
  }
}
