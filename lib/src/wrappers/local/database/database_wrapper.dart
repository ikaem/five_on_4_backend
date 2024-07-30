import 'package:drift/backends.dart';

import '../../libraries/drift/app_database.dart';

class DatabaseWrapper {
  DatabaseWrapper({
    required DelegatedDatabase delegatedDatabase,
  }) : _delegatedDatabase = delegatedDatabase;

  final DelegatedDatabase _delegatedDatabase;

  AppDatabase? _db;

  AppDatabase get db {
    final initializedDb = _db;

    if (initializedDb == null) {
      // TODO have better exception
      throw Exception("Database not initialized");
    }

    return initializedDb;
  }

  $PlayerEntityTable get playersRepo => db.playerEntity;
  $AuthEntityTable get authRepo => db.authEntity;
  $MatchEntityTable get matchesRepo => db.matchEntity;

  bool get isInitialized {
    // TODO maybe there is some better way for thsi
    return _db != null;
  }

  Future<void> initialize() async {
    try {
      final db = AppDatabase(_delegatedDatabase);

      // Needed initial query to make sure that any migrations are immediately run
      final dbCurrentTime = await db.current_timestamp().get();
      // TODO do remove this manually via dbeaver
      // await db.customStatement("CREATE EXTENSION IF NOT EXISTS pg_trgm;");
      await db.customStatement("CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;");
      print("DB current time: $dbCurrentTime");

      _db = db;
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future<T> transaction<T>(
    Future<T> Function() action, {
    bool requireNew = false,
  }) async {
    return db.transaction(action, requireNew: requireNew);
  }

  Future<void> close() async {
    await db.close();
  }
}
