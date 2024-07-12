// import "../../repositories/matches_repository.dart";
import "package:five_on_4_backend/src/features/matches/domain/repositories/matches_repository.dart";

class SearchMatchesUseCase {
  SearchMatchesUseCase({
    required MatchesRepository matchesRepository,
  }) : _matchesRepository = matchesRepository;

  final MatchesRepository _matchesRepository;
}
