import '../../../../wrappers/libraries/drift/app_database.dart';

abstract class PlayersDataSource {
  Future<PlayerEntityData?> getPlayerByAuthId({
    required int authId,
  });

  Future<PlayerEntityData?> getPlayerById({
    required int id,
  });
}
