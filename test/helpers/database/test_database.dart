import 'package:drift/backends.dart';
import 'package:drift/native.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';

import 'package:five_on_4_backend/src/wrappers/local/database/database_wrapper.dart';

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

// TODO probably deprecated
Future<TestDatabaseWrapper> getTestMemoryDatabaseWrapper() async {
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

Future<TestDatabaseWrapper> getTestPostgresDatabaseWrapper() async {
  final db = DatabaseWrapper(
    delegatedDatabase: TestPosgresDelegatedDatabaseWrapper().delegatedDatabase,
  );

  await db.initialize();

  final testDatabaseWrapper = TestDatabaseWrapper(
    databaseWrapper: db,
  );

  return testDatabaseWrapper;
}

class TestPosgresDelegatedDatabaseWrapper {
  DelegatedDatabase get delegatedDatabase {
    final PgDatabase pgDatabase = PgDatabase(
      endpoint: Endpoint(
        host: "localhost",
        username: "admin",
        password: "root",
        database: "defaultdb",
        port: 5432,
      ),
      settings: ConnectionSettings(
        // TODO not sure about this - we will see
        // sslMode: SslMode.require,
        // TODO research which is better
        // sslMode: SslMode.verifyFull,
        sslMode: SslMode.disable,
        onOpen: (connection) async {
          print("Connected!");
        },
      ),
    );

    return pgDatabase;
  }
}
