import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';

import '../../../features/auth/data/entities/auth/auth_entity.dart';
import '../../../features/matches/data/entities/match/match_entity.dart';
import '../../../features/players/data/entities/player/player_entity.dart';
import '../../../features/teams/data/entities/team/team_entity.dart';
import 'migrations/migration_wrapper.dart';

part "app_database.g.dart";

@DriftDatabase(
  tables: [
    AuthEntity,
    PlayerEntity,
    TeamEntity,
    MatchEntity,
    PlayerMatchParticipationEntity,
  ],
  queries: {
    "current_timestamp": "SELECT CURRENT_TIMESTAMP;",
    // "levenstein": "SELECT LEVENSHTEIN(?, ?);",
    // "enablePgTrgm": "CREATE EXTENSION IF NOT EXISTS pg_trgm;",
  },
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(
    super.e,
  );

  final MigrationWrapper _migrationWrapper = MigrationWrapper();

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => _migrationWrapper.migration;
}


/* 


@DriftDatabase(
  tables: [Users],
  queries: {
    'userById': 'SELECT * FROM users WHERE id = ?',
  },
)
Drift will generate two methods for you: userById(int id) and watchUserById(int id).




 */