import '../../data/data_sources/matches_data_source.dart';
import '../../utils/converters/matches_converters.dart';
import '../models/match_model.dart';
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
}
