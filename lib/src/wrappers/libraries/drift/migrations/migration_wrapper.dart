import 'package:drift/drift.dart';
import 'schema_versions/schema_versions.dart';

/// To make it easier to modify this and not having to modify Database file
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
    ),
    beforeOpen: (details) async {
      // some populate things if needed
    },
  );
}
