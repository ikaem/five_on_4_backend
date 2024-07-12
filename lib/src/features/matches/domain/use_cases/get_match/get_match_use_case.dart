import '../../models/match_model.dart';
import '../../repositories/matches_repository.dart';

class GetMatchUseCase {
  GetMatchUseCase({
    required MatchesRepository matchesRepository,
  }) : _matchesRepository = matchesRepository;

  final MatchesRepository _matchesRepository;

  Future<MatchModel?> call({required int matchId}) {
    return _matchesRepository.getMatch(
      matchId: matchId,
    );
  }
}
