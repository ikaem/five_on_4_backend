import '../../data/data_sources/players_data_source.dart';
import '../../utils/converters/players_converter.dart';
import '../models/player_model.dart';
import 'players_repository.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  PlayersRepositoryImpl({
    required PlayersDataSource playersDataSource,
  }) : _playersDataSource = playersDataSource;

  final PlayersDataSource _playersDataSource;

  @override
  Future<PlayerModel?> getPlayerByAuthId({
    required int authId,
  }) async {
    final playerEntityData = await _playersDataSource.getPlayerByAuthId(
      authId: authId,
    );

    if (playerEntityData == null) {
      return null;
    }

    final model = PlayersConverter.modelFromEntity(entity: playerEntityData);

    return model;
  }

  @override
  Future<PlayerModel?> getPlayerById({
    required int id,
  }) async {
    final playerEntityData = await _playersDataSource.getPlayerById(
      id: id,
    );
    if (playerEntityData == null) {
      return null;
    }

    final model = PlayersConverter.modelFromEntity(entity: playerEntityData);

    return model;
  }
}
