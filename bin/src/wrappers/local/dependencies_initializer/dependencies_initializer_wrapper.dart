import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../features/auth/data/data_sources/auth_data_source_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../features/auth/presentation/router/auth_router.dart';
import '../../../features/core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../features/core/presentation/router/app_router.dart';
import '../../../features/matches/data/data_sources/matches_data_source_impl.dart';
import '../../../features/matches/domain/repositories/matches_repository_impl.dart';
import '../../../features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../features/matches/presentation/controllers/get_match_controller.dart';
import '../../../features/matches/presentation/router/matches_router.dart';
import '../../../features/players/data/data_sources/players_data_source_impl.dart';
import '../../../features/players/domain/repositories/players_repository_impl.dart';
import '../../../features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../libraries/crypt/crypt_wrapper.dart';
import '../../libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../libraries/dio/dio_wrapper.dart';
import '../cookies_handler/cookies_handler_wrapper.dart';
import '../database/database_wrapper.dart';
import '../env_vars/env_vars_wrapper.dart';
import '../google_apis/google_apis_wrapper.dart';

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

    // instances
    final dio = Dio();

    // wrappers
    final dioWrapper = DioWrapper(dio: dio);
    final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
      jwtSecret: _envVarsWrapper.authWrapper.jwtSecret,
    );
    final googleApisWrapper = GoogleApisWrapper(dioWrapper: dioWrapper);
    final cryptWrapper =
        CryptWrapper(passwordSalt: _envVarsWrapper.authWrapper.passwordSalt);
    final cookiesHandlerWrapper = CookiesHandlerWrapper();

    // final data sources
    final authDataSource = AuthDataSourceImpl(
      databaseWrapper: _databaseWrapper,
      cryptWrapper: cryptWrapper,
    );
    final playersDataSource = PlayersDataSourceImpl(
      databaseWrapper: _databaseWrapper,
    );
    final matchesDataSource =
        MatchesDataSourceImpl(databaseWrapper: _databaseWrapper);

    // repositories
    final authRepository = AuthRepositoryImpl(
      authDataSource: authDataSource,
      googleApisWrapper: googleApisWrapper,
    );
    final playersRepository =
        PlayersRepositoryImpl(playersDataSource: playersDataSource);
    final matchesRespository =
        MatchesRepositoryImpl(matchesDataSource: matchesDataSource);

    // use cases
    final googleLoginUseCase =
        GoogleLoginUseCase(authRepository: authRepository);
    final getPlayerByAuthIdUseCase =
        GetPlayerByAuthIdUseCase(playersRepository: playersRepository);
    final createJWTAccessTokenCookieUseCase = CreateJWTAccessTokenCookieUseCase(
      dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
    );
    final getMatchUseCase =
        GetMatchUseCase(matchesRepository: matchesRespository);
    final getPlayerByIdUseCase =
        GetPlayerByIdUseCase(playersRepository: playersRepository);
    final getAuthByIdUseCase =
        GetAuthByIdUseCase(authRepository: authRepository);
    final getCookieByNameInStringUseCase = GetCookieByNameInStringUseCase(
      cookiesHandlerWrapper: cookiesHandlerWrapper,
    );
    final getAccessTokenDataFromAccessJwtUseCase =
        GetAccessTokenDataFromAccessJwtUseCase(
      dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
    );

    // controllers
    final googleLoginController = GoogleLoginController(
      googleLoginUseCase: googleLoginUseCase,
      getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
      createJWTAccessTokenCookieUseCase: createJWTAccessTokenCookieUseCase,
    );
    final getMatchController = GetMatchController(
      getMatchUseCase: getMatchUseCase,
      getPlayerByIdUseCase: getPlayerByIdUseCase,
      getAuthByIdUseCase: getAuthByIdUseCase,
      getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
      getAccessTokenDataFromAccessJwtUseCase:
          getAccessTokenDataFromAccessJwtUseCase,
    );

    // router
    final authRouter = AuthRouter(
      googleLoginController: googleLoginController,
    );
    final matchesRouter = MatchesRouter(
      getMatchController: getMatchController,
    );

    final AppRouter appRouter = AppRouter(
      authRouter: authRouter,
      matchesRouter: matchesRouter,
    );
    _appRouter = appRouter;
  }
}

// Middleware someRandomMiddleware() {
// // retun
// }
