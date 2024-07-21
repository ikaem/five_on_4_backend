import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../domain/models/match_model.dart';

// TODO this needs to be tested
abstract class MatchesConverter {
  // do not allow extending
  MatchesConverter._();

  static MatchModel modelFromEntity({
    required MatchEntityData entity,
  }) {
    final model = MatchModel(
      id: entity.id,
      title: entity.title,
      dateAndTime: entity.dateAndTime.millisecondsSinceEpoch,
      location: entity.location,
      description: entity.description,
    );

    return model;
  }
}
