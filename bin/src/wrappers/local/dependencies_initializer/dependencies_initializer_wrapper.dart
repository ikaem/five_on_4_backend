import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:stormberry/stormberry.dart';

import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../features/auth/presentation/router/auth_router.dart';
import '../../../features/core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../features/core/presentation/router/app_router.dart';
import '../../../features/matches/presentation/router/matches_router.dart';
import '../../../features/players/domain/repositories/players_repository.dart';
import '../../../features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
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
      throw Exception("Database not initialized");
    }

    // wrappers
    final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(jwtSecret: _envVarsWrapper.);


    // repositories
    final authRepository = AuthRepository();
    final playersRepository = PlayersRepository();

    // use cases
    final googleLoginUseCase =
        GoogleLoginUseCase(authRepository: authRepository);
    final getPlayerByAuthIdUseCase =
        GetPlayerByAuthIdUseCase(playersRepository: playersRepository);
    final createJWTAccessTokenCookieUseCase = CreateJWTAccessTokenCookieUseCase(
        dartJsonWebTokenWrapper: dartJsonWebTokenWrapper);

    // controllers
    final googleLoginController = GoogleLoginController(
      googleLoginUseCase: googleLoginUseCase,
      getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
      createJWTAccessTokenCookieUseCase: createJWTAccessTokenCookieUseCase,
    );

    // router
    final authRouter = AuthRouter(
      googleLoginController: googleLoginController,
    );
    final matchesRouter = MatchesRouter();

    final AppRouter appRouter = AppRouter(
      authRouter: authRouter,
    );
    _appRouter = appRouter;
  }
}

// Middleware someRandomMiddleware() {
// // retun
// }
