import '../models/match_model.dart';
import '../values/create_match_value.dart';

abstract interface class MatchesRepository {
  Future<MatchModel?> getMatch({
    required int matchId,
  });

  Future<int> createMatch({
    required CreateMatchValue createMatchValue,
  });

  Future<List<MatchModel>> getPlayerMatchesOverview({
    required int playerId,
  });
}
