import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../domain/values/create_match_value.dart';

abstract interface class MatchesDataSource {
  Future<MatchEntityData?> getMatch({
    required int matchId,
  });

  Future<int> createMatch({
    required CreateMatchValue createMatchValue,
  });

  /// returns a list of matches that the player is a participant in
  ///
  /// returned value is a list of matches that includes max 5 of each:
  /// - upcoming matches
  /// - today matches
  /// - past matches
  Future<List<MatchEntityData>> getPlayerMatchesOverview({
    required int playerId,
  });
}
