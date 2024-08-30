import 'package:five_on_4_backend/src/features/matches/domain/values/match_entity_value.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/models/player_match_participation_model.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../domain/models/match_model.dart';

// TODO this needs to be tested
abstract class MatchesConverter {
  // do not allow extending
  MatchesConverter._();

  // TODO deprecated - this should be replaced with using matchentityvalue
  static MatchModel modelFromEntity({
    required MatchEntityData entity,
  }) {
    final model = MatchModel(
      id: entity.id,
      title: entity.title,
      dateAndTime: entity.dateAndTime.millisecondsSinceEpoch,
      location: entity.location,
      description: entity.description,
      participations: [],
    );

    return model;
  }

  static MatchModel modelFromEntityValue({
    required MatchEntityValue entity,
  }) {
    final partipations = entity.participtions
        .map(
          (participation) => PlayerMatchParticipationModel(
            id: participation.id,
            matchId: participation.matchId,
            playerId: participation.playerId,
            status: participation.status.name,
            playerNickname: participation.playerNickname,
          ),
        )
        .toList();

    final match = MatchModel(
      id: entity.id,
      title: entity.title,
      dateAndTime: entity.dateAndTime.millisecondsSinceEpoch,
      location: entity.location,
      description: entity.description,
      participations: partipations,
    );

    return match;
  }
}
