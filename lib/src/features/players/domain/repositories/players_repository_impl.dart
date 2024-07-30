import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';

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

  @override
  Future<List<PlayerModel>> searchPlayers({
    required PlayersSearchFilterValue filter,
  }) async {
    final players = await _playersDataSource.searchPlayers(
      filter: filter,
    );

    final playerModels = players
        .map(
          (player) => PlayersConverter.modelFromEntity(
            entity: player,
          ),
        )
        .toList();

    return playerModels;
  }
}
