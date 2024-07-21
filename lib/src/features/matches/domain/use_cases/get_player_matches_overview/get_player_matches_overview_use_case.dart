import '../../models/match_model.dart';
import '../../repositories/matches_repository.dart';

class GetPlayerMatchesOverviewUseCase {
  GetPlayerMatchesOverviewUseCase({
    required MatchesRepository matchesRepository,
  }) : _matchesRepository = matchesRepository;

  final MatchesRepository _matchesRepository;

  Future<List<MatchModel>> call({required int playerId}) {
    return _matchesRepository.getPlayerMatchesOverview(
      playerId: playerId,
    );
  }
}
