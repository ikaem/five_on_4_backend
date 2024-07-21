import '../../data/data_sources/matches_data_source.dart';
import '../../utils/converters/matches_converters.dart';
import '../models/match_model.dart';
import '../values/create_match_value.dart';
import '../values/match_search_filter_value.dart';
import 'matches_repository.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  MatchesRepositoryImpl({
    required this.matchesDataSource,
  });

  final MatchesDataSource matchesDataSource;

  @override
  Future<MatchModel?> getMatch({
    required int matchId,
  }) async {
    final matchEntityData = await matchesDataSource.getMatch(
      matchId: matchId,
    );
    if (matchEntityData == null) {
      return null;
    }

    final match = MatchesConverter.modelFromEntity(
      entity: matchEntityData,
    );

    return match;
  }

  @override
  Future<int> createMatch({required CreateMatchValue createMatchValue}) async {
    final id = await matchesDataSource.createMatch(
      createMatchValue: createMatchValue,
    );

    return id;
  }

  @override
  Future<List<MatchModel>> getPlayerMatchesOverview({
    required int playerId,
  }) async {
    final matches = await matchesDataSource.getPlayerMatchesOverview(
      playerId: playerId,
    );

    final matchModels = matches
        .map(
          (match) => MatchesConverter.modelFromEntity(
            entity: match,
          ),
        )
        .toList();

    return matchModels;
  }

  @override
  Future<List<MatchModel>> searchMatches(
      {required MatchSearchFilterValue filter}) async {
    final matches = await matchesDataSource.searchMatches(
      filter: filter,
    );

    final matchModels = matches
        .map((match) => MatchesConverter.modelFromEntity(entity: match))
        .toList();

    return matchModels;
  }
}
