import 'package:drift/drift.dart';

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
  ],
  queries: {"current_timestamp": "SELECT CURRENT_TIMESTAMP;"},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(
    super.e,
  );

  final MigrationWrapper _migrationWrapper = MigrationWrapper();

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => _migrationWrapper.migration;
}
