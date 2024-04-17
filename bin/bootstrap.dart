import 'dart:io';

import 'src/features/core/presentation/router/app_router.dart';
import 'src/server.dart';
import 'src/wrappers/local/database/database_wrapper.dart';
import 'src/wrappers/local/database/postgres_delegated_database_wrapper.dart';
import 'src/wrappers/local/dependencies_initializer/dependencies_initializer_wrapper.dart';
import 'src/wrappers/local/env_vars/env_vars_wrapper.dart';

Future<void> boostrap() async {
  final envVarWrapper = EnvVarsWrapper();

  final initializedDatabaseWrapper = await _getInitializedDatabaseWrapper(
    envVarWrapper: envVarWrapper,
  );
  final appRouter = _getInitializedAppRouter(
    databaseWrapper: initializedDatabaseWrapper,
    envVarsWrapper: envVarWrapper,
  );

  final server = Server(
    appRouter: appRouter,
  );

  // const port = envVarsWrapper.server.port
  const port = 8080;

  server.start(
    port: port,
    ip: InternetAddress.anyIPv4,
  );
}

// TODO this could be done in the initializer as well
Future<DatabaseWrapper> _getInitializedDatabaseWrapper({
  required EnvVarsWrapper envVarWrapper,
}) async {
  final delegatedDatabase = PostgresDelegatedDatabaseWrapper(
    envVarsDBWrapper: envVarWrapper.dbWrapper,
  ).delegatedDatabase;
  final dbWrapper = DatabaseWrapper(
    delegatedDatabase: delegatedDatabase,
  );

  await dbWrapper.initialize();

  return dbWrapper;
}

AppRouter _getInitializedAppRouter({
  required DatabaseWrapper databaseWrapper,
  required EnvVarsWrapper envVarsWrapper,
}) {
  final dependenciesInitializerWrapper = DependenciesInitializerWrapper(
    databaseWrapper: databaseWrapper,
    envVarsWrapper: envVarsWrapper,
  );
  dependenciesInitializerWrapper.initialize();

  final appRouter = dependenciesInitializerWrapper.appRouter;

  return appRouter;
}
