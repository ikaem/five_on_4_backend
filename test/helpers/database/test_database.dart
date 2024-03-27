import 'package:drift/native.dart';

import '../../../bin/src/wrappers/local/database/database_wrapper.dart';

class TestDatabaseWrapper {
  TestDatabaseWrapper({
    required this.databaseWrapper,
  });

  final DatabaseWrapper databaseWrapper;

  // Future<void> clearAll() async {
  //   // TODO not needed even
  //   await databaseWrapper.transaction(() async {
  //     for (final table in databaseWrapper.db.allTables) {
  //       // TODO not sure if all should happening
  //       // TODO maybe we dont even need to do this
  //       await databaseWrapper.db.delete(table).go();
  //     }

  //     // await db.delete(db.playerEntity).go();
  //     // await db.delete(db.authEntity).go();
  //   });
  // }
}

Future<TestDatabaseWrapper> getTestDatabaseWrapper() async {
  final db = DatabaseWrapper(
      delegatedDatabase: NativeDatabase.memory(
          // logStatements: true,
          ));

  await db.initialize();

  final testDatabaseWrapper = TestDatabaseWrapper(
    databaseWrapper: db,
  );

  return testDatabaseWrapper;
}
