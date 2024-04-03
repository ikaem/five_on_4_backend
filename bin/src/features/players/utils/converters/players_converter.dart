import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../data/entities/player/player_entity.dart';
import '../../domain/models/player_model.dart';

abstract class PlayersConverter {
  static PlayerModel modelFromEntity({
    required PlayerEntityData entity,
  }) {
    // TOD Otest this
    final name = '${entity.firstName} ${entity.lastName}';

    final model = PlayerModel(
      id: entity.id,
      name: name,
      nickname: entity.nickname,
    );

    return model;
  }
}
