import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/matches/data/entities/match/match_entity.dart';
import 'package:five_on_4_backend/src/features/players/data/entities/player/player_entity.dart';

class PlayerMatchParticipationEntity extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // refs
  IntColumn get playerId => integer().references(PlayerEntity, #id)();
  IntColumn get matchId => integer().references(MatchEntity, #id)();

  @override
  // TODO: implement uniqueKeys
  List<Set<Column<Object>>>? get uniqueKeys => [
        {playerId, matchId}
      ];
}
