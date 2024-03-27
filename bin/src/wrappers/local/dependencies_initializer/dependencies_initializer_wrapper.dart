import 'dart:developer';

import 'package:stormberry/stormberry.dart';

import '../../../features/auth/presentation/router/auth_router.dart';
import '../../../features/core/presentation/router/app_router.dart';
import '../database/database_wrapper.dart';
import '../env_vars/env_vars_wrapper.dart';

class DependenciesInitializerWrapper {
  DependenciesInitializerWrapper({
    required DatabaseWrapper databaseWrapper,
    required EnvVarsWrapper envVarsWrapper,
  })  : _databaseWrapper = databaseWrapper,
        _envVarsWrapper = envVarsWrapper;

  final DatabaseWrapper _databaseWrapper;
  final EnvVarsWrapper _envVarsWrapper;

  AppRouter? _appRouter;
  AppRouter get appRouter {
    final router = _appRouter;
    if (router == null) {
      // TODO make better exception
      log("Router not initialized");
      throw Exception("Router not initialized");
    }

    return router;
  }

  void initialize() {
    final isDbInitialized = _databaseWrapper.isInitialized;
    if (!isDbInitialized) {
      final pgHost = String.fromEnvironment("WHAT");
      print("pgHost: $pgHost");
      // TODO make better exception
      log("Database not initialized");
      // throw Exception("Database not initialized");
    }

    // router
    final authRouter = AuthRouter();

    final AppRouter appRouter = AppRouter(
      authRouter: authRouter,
    );
    _appRouter = appRouter;
  }
}
