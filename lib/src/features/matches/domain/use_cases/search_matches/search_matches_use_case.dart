// import "../../repositories/matches_repository.dart";
import "package:five_on_4_backend/src/features/matches/domain/models/match_model.dart";
import "package:five_on_4_backend/src/features/matches/domain/repositories/matches_repository.dart";
import "package:five_on_4_backend/src/features/matches/domain/values/match_search_filter_value.dart";

class SearchMatchesUseCase {
  SearchMatchesUseCase({
    required MatchesRepository matchesRepository,
  }) : _matchesRepository = matchesRepository;

  final MatchesRepository _matchesRepository;

  Future<List<MatchModel>> call({
    required MatchSearchFilterValue filter,
  }) async {
    return _matchesRepository.searchMatches(filter: filter);
  }
}
