import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/auth/data/entities/auth/auth_entity.dart';
import 'package:five_on_4_backend/src/features/teams/data/entities/team/team_entity.dart';

class PlayerEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get nickname => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  // refs
  IntColumn get authId => integer().references(AuthEntity, #id)();
  // TODO nullable for now
  IntColumn get teamId => integer().references(TeamEntity, #id).nullable()();
}
