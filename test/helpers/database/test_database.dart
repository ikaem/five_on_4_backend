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

  Future<void> clearAll() async {
    await databaseWrapper.transaction(() async {
      // TODO make sure this is done in order i guess
      // 1. delete matches
      await databaseWrapper.db.delete(databaseWrapper.db.playerEntity).go();
      // 2. delete players
      await databaseWrapper.db.delete(databaseWrapper.db.playerEntity).go();
      // 3. delete auth
      await databaseWrapper.db.delete(databaseWrapper.db.authEntity).go();
    });
  }
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
