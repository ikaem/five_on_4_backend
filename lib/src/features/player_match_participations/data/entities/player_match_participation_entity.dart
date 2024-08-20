import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/matches/data/entities/match/match_entity.dart';
import 'package:five_on_4_backend/src/features/players/data/entities/player/player_entity.dart';

class PlayerMatchParticipationEntity extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  // TODO maybe there are some accepted values
  IntColumn get status => intEnum<PlayerMatchParticipationStatus>()();

  // refs
  IntColumn get playerId => integer().references(PlayerEntity, #id)();
  IntColumn get matchId => integer().references(MatchEntity, #id)();

  @override
  // TODO: implement uniqueKeys
  List<Set<Column<Object>>>? get uniqueKeys => [
        {playerId, matchId}
      ];
}

// TODO not sure if this could be private
// TODO leave this here for now
enum PlayerMatchParticipationStatus {
  pendingDecision,
  arriving,
  notArriving,
  // TODO if any other are added, they need to be added at the end of list to account for indexes of each enum and avoid migration
  unknown,
}
