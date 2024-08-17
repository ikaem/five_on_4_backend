import 'package:drift/drift.dart';
import 'schema_versions/schema_versions.dart';

/// To make it easier to modify this and not having to modify Database file
///
// TODO also, taske a look at this with migrations
// https://drift.simonbinder.eu/docs/migrations/#tips
class MigrationWrapper {
  final MigrationStrategy migration = MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // await m.addColumn(schema.users, schema.users.nickname);
        await m.createTable(schema.matchEntity);
      },
      from2To3: (m, schema) async {
        // await m.createTable(schema.somethingElse);
        await m.addColumn(schema.matchEntity, schema.matchEntity.title);
      },
      from3To4: (Migrator m, Schema4 schema) async {
        await m.createTable(schema.playerMatchParticipationEntity);
      },
      from4To5: (Migrator m, Schema5 schema) async {
        // TODO this seems to be enough to enforce adding unique key constraint on a table
        // in this case, it was for playerId, matchId combined column
        await m
            .alterTable(TableMigration(schema.playerMatchParticipationEntity));

        // await m.drop(schema.playerMatchParticipationEntity);
        // await m.createTable(schema.playerMatchParticipationEntity);
      },
      from5To6: (Migrator m, Schema6 schema) async {
        await m.addColumn(schema.playerMatchParticipationEntity,
            schema.playerMatchParticipationEntity.status);
      },
    ),
    beforeOpen: (details) async {
      // some populate things if needed
    },
  );
}
