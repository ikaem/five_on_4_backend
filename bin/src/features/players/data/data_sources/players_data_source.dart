import '../../../../wrappers/libraries/drift/app_database.dart';

abstract class PlayersDataSource {
  Future<PlayerEntityData?> getPlayerByAuthId({
    required int authId,
  });
}
