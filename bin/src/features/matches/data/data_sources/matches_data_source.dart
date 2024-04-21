import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../domain/values/create_match_value.dart';

abstract interface class MatchesDataSource {
  Future<MatchEntityData?> getMatch({
    required int matchId,
  });

  Future<int> createMatch({
    required CreateMatchValue createMatchValue,
  });
}
