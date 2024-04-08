import '../../../../wrappers/libraries/drift/app_database.dart';

abstract interface class MatchesDataSource {
  Future<MatchEntityData?> getMatch({
    required int matchId,
  });
}
