import 'dart:developer';

import 'package:dio/dio.dart' hide Response;

import '../../../features/auth/data/data_sources/auth_data_source.dart';
import '../../../features/auth/data/data_sources/auth_data_source_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../features/auth/domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';
import '../../../features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../features/auth/presentation/controllers/logout/logout_controller.dart';
import '../../../features/auth/presentation/controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';
import '../../../features/auth/presentation/router/auth_router.dart';
import '../../../features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import '../../../features/auth/utils/validators/authorize_request_validator.dart';
import '../../../features/core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../features/core/presentation/router/app_router.dart';
import '../../../features/matches/data/data_sources/matches_data_source.dart';
import '../../../features/matches/data/data_sources/matches_data_source_impl.dart';
import '../../../features/matches/domain/repositories/matches_repository.dart';
import '../../../features/matches/domain/repositories/matches_repository_impl.dart';
import '../../../features/matches/domain/use_cases/create_match/create_match_use_case.dart';
import '../../../features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../features/matches/presentation/controllers/create_match_controller.dart';
import '../../../features/matches/presentation/controllers/get_match_controller.dart';
import '../../../features/matches/presentation/router/matches_router.dart';
import '../../../features/matches/utils/middlewares/match_create_request_middleware_wrapper.dart';
import '../../../features/matches/utils/validators/match_create_request_validator.dart';
import '../../../features/players/data/data_sources/players_data_source.dart';
import '../../../features/players/data/data_sources/players_data_source_impl.dart';
import '../../../features/players/domain/repositories/players_repository.dart';
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

    // wrappers
    final initializedWrappers =
        getInitializedWrappers(envVarsWrapper: _envVarsWrapper);

    // data sources
    final initializedDataSources = getInitializedDataSources(
        initializedWrappers: initializedWrappers,
        databaseWrapper: _databaseWrapper);

    // repositories

    final initializedRepositories = getInitializedRepositories(
      initializedDataSources: initializedDataSources,
      initializedWrappers: initializedWrappers,
    );

    // use cases
    final initializedUseCases = getInitializedUseCases(
      initializedRepositories: initializedRepositories,
      initializedWrappers: initializedWrappers,
    );

    // controllers
    final initializedControllers = getInitializedControllers(
      initializedUseCases: initializedUseCases,
    );

    // validators
    final initializedValidators = getInitializedValidators(
      initializedUseCases: initializedUseCases,
    );

    // middleware wrappers
    final initializedMiddlewareWrappers = getInitializedMiddlewareWrappers(
      initializedValidators: initializedValidators,
    );

    // routers
    final initializedRouters = getInitializedRouters(
      initializedControllers: initializedControllers,
      initializedMiddlewareWrappers: initializedMiddlewareWrappers,
    );
    final (
      authRouter,
      matchesRouter,
    ) = initializedRouters;

    final AppRouter appRouter = AppRouter(
      authRouter: authRouter,
      matchesRouter: matchesRouter,
    );
    _appRouter = appRouter;
  }
}

typedef InitializedWrappers = (
  DioWrapper dioWrapper,
  DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
  GoogleApisWrapper googleApisWrapper,
  CryptWrapper cryptWrapper,
  CookiesHandlerWrapper cookiesHandlerWrapper,
);
InitializedWrappers getInitializedWrappers({
  required EnvVarsWrapper envVarsWrapper,
}) {
  final dio = Dio();

  final dioWrapper = DioWrapper(dio: dio);
  final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
    jwtSecret: envVarsWrapper.authWrapper.jwtSecret,
  );
  final googleApisWrapper = GoogleApisWrapper(dioWrapper: dioWrapper);
  final cryptWrapper = CryptWrapper(
    passwordSalt: envVarsWrapper.authWrapper.passwordSalt,
  );
  final cookiesHandlerWrapper = CookiesHandlerWrapper();

  return (
    dioWrapper,
    dartJsonWebTokenWrapper,
    googleApisWrapper,
    cryptWrapper,
    cookiesHandlerWrapper,
  );
}

typedef InitializedDataSources = (
  AuthDataSource authDataSource,
  PlayersDataSource playersDataSource,
  MatchesDataSource matchesDataSource,
);
InitializedDataSources getInitializedDataSources({
  required InitializedWrappers initializedWrappers,
  required DatabaseWrapper databaseWrapper,
}) {
  final (
    _,
    _,
    _,
    cryptWrapper,
    _,
  ) = initializedWrappers;

  final authDataSource = AuthDataSourceImpl(
    databaseWrapper: databaseWrapper,
    cryptWrapper: cryptWrapper,
  );
  final playersDataSource = PlayersDataSourceImpl(
    databaseWrapper: databaseWrapper,
  );
  final matchesDataSource =
      MatchesDataSourceImpl(databaseWrapper: databaseWrapper);

  return (
    authDataSource,
    playersDataSource,
    matchesDataSource,
  );
}

typedef InitializedRepositories = (
  AuthRepository authRepository,
  PlayersRepository playersRepository,
  MatchesRepository matchesRepository,
);
InitializedRepositories getInitializedRepositories({
  required InitializedDataSources initializedDataSources,
  required InitializedWrappers initializedWrappers,
}) {
  final (
    _,
    _,
    googleApisWrapper,
    _,
    _,
  ) = initializedWrappers;
  final (
    authDataSource,
    playersDataSource,
    matchesDataSource,
  ) = initializedDataSources;

  final authRepository = AuthRepositoryImpl(
    authDataSource: authDataSource,
    googleApisWrapper: googleApisWrapper,
  );
  final playersRepository = PlayersRepositoryImpl(
    playersDataSource: playersDataSource,
  );
  final matchesRespository = MatchesRepositoryImpl(
    matchesDataSource: matchesDataSource,
  );

  return (
    authRepository,
    playersRepository,
    matchesRespository,
  );
}

typedef InitializedUseCases = (
  GoogleLoginUseCase googleLoginUseCase,
  GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
  CreateJWTAccessTokenCookieUseCase createJWTAccessTokenCookieUseCase,
  GetMatchUseCase getMatchUseCase,
  GetPlayerByIdUseCase getPlayerByIdUseCase,
  GetAuthByIdUseCase getAuthByIdUseCase,
  GetCookieByNameInStringUseCase getCookieByNameInStringUseCase,
  GetAccessTokenDataFromAccessJwtUseCase getAccessTokenDataFromAccessJwtUseCase,
  CreateMatchUseCase createMatchUseCase,
  GetAuthByEmailUseCase getAuthByEmailUseCase,
  GetHashedValueUseCase getHashedValueUseCase,
  RegisterWithEmailAndPasswordUseCase registerWithEmailAndPasswordUseCase,
);
InitializedUseCases getInitializedUseCases({
  required InitializedRepositories initializedRepositories,
  required InitializedWrappers initializedWrappers,
}) {
  final (
    authRepository,
    playersRepository,
    matchesRespository,
  ) = initializedRepositories;
  final (
    _,
    dartJsonWebTokenWrapper,
    _,
    cryptWrapper,
    cookiesHandlerWrapper,
  ) = initializedWrappers;

  final googleLoginUseCase = GoogleLoginUseCase(authRepository: authRepository);
  final getPlayerByAuthIdUseCase =
      GetPlayerByAuthIdUseCase(playersRepository: playersRepository);
  final createJWTAccessTokenCookieUseCase = CreateJWTAccessTokenCookieUseCase(
    dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
  );
  final getMatchUseCase =
      GetMatchUseCase(matchesRepository: matchesRespository);
  final getPlayerByIdUseCase =
      GetPlayerByIdUseCase(playersRepository: playersRepository);
  final getAuthByIdUseCase = GetAuthByIdUseCase(authRepository: authRepository);
  final getCookieByNameInStringUseCase = GetCookieByNameInStringUseCase(
    cookiesHandlerWrapper: cookiesHandlerWrapper,
  );
  final getAccessTokenDataFromAccessJwtUseCase =
      GetAccessTokenDataFromAccessJwtUseCase(
    dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
  );
  final createMatchUseCase = CreateMatchUseCase(
    matchesRepository: matchesRespository,
  );
  final getAuthByEmailUseCase = GetAuthByEmailUseCase(
    authRepository: authRepository,
  );
  final getHashedValueUseCase = GetHashedValueUseCase(
    cryptWrapper: cryptWrapper,
  );
  final registerWithEmailAndPasswordUseCase =
      RegisterWithEmailAndPasswordUseCase(
    authRepository: authRepository,
  );

  return (
    googleLoginUseCase,
    getPlayerByAuthIdUseCase,
    createJWTAccessTokenCookieUseCase,
    getMatchUseCase,
    getPlayerByIdUseCase,
    getAuthByIdUseCase,
    getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase,
    createMatchUseCase,
    getAuthByEmailUseCase,
    getHashedValueUseCase,
    registerWithEmailAndPasswordUseCase,
  );
}

typedef InitializedControllers = (
  GoogleLoginController googleLoginController,
  GetMatchController getMatchController,
  CreateMatchController createMatchController,
  LogoutController logoutController,
  RegisterWithEmailAndPasswordController registerWithEmailAndPasswordController,
);
InitializedControllers getInitializedControllers({
  required InitializedUseCases initializedUseCases,
}) {
  final (
    googleLoginUseCase,
    getPlayerByAuthIdUseCase,
    createJWTAccessTokenCookieUseCase,
    getMatchUseCase,
    _,
    _,
    _,
    _,
    createMatchUseCase,
    getAuthByEmailUseCase,
    getHashedValueUseCase,
    registerWithEmailAndPasswordUseCase,
  ) = initializedUseCases;

  final googleLoginController = GoogleLoginController(
    googleLoginUseCase: googleLoginUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    createJWTAccessTokenCookieUseCase: createJWTAccessTokenCookieUseCase,
  );
  final getMatchController = GetMatchController(
    getMatchUseCase: getMatchUseCase,
  );
  final createMatchController =
      CreateMatchController(createMatchUseCase: createMatchUseCase);
  final logoutController = LogoutController();
  final registerWithEmailAndPasswordController =
      RegisterWithEmailAndPasswordController(
    getAuthByEmailUseCase: getAuthByEmailUseCase,
    getHashedValueUseCase: getHashedValueUseCase,
    registerWithEmailAndPasswordUseCase: registerWithEmailAndPasswordUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    createJWTAccessTokenCookieUseCase: createJWTAccessTokenCookieUseCase,
  );

  return (
    googleLoginController,
    getMatchController,
    createMatchController,
    logoutController,
    registerWithEmailAndPasswordController,
  );
}

typedef InitializedValidators = (
  AuthorizeRequestValidator requestAuthorizationValidator,
  MatchCreateRequestValidator matchCreateRequestValidator,
);
InitializedValidators getInitializedValidators({
  required InitializedUseCases initializedUseCases,
}) {
  final (
    _,
    _,
    _,
    _,
    getPlayerByIdUseCase,
    getAuthByIdUseCase,
    getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase,
    _,
    _,
    _,
    _,
  ) = initializedUseCases;

  final requestAuthorizationValidator = AuthorizeRequestValidator(
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
  );
  final matchCreateRequestValidator = MatchCreateRequestValidator();

  return (
    requestAuthorizationValidator,
    matchCreateRequestValidator,
  );
}

typedef InitializedMiddlewareWrappers = (
  RequestAuthorizationMiddlewareWrapper requestAuthorizationMiddleware,
  MatchCreateRequestMiddlewareWrapper matchCreateRequestMiddleware,
);
InitializedMiddlewareWrappers getInitializedMiddlewareWrappers({
  required InitializedValidators initializedValidators,
}) {
  final (
    requestAuthorizationValidator,
    matchCreateRequestValidator,
  ) = initializedValidators;

  final requestAuthorizationMiddleware = RequestAuthorizationMiddlewareWrapper(
    requestHandler: requestAuthorizationValidator.validate,
  );
  final matchCreateRequestMiddleware = MatchCreateRequestMiddlewareWrapper(
    requestHandler: matchCreateRequestValidator.validate,
  );

  return (
    requestAuthorizationMiddleware,
    matchCreateRequestMiddleware,
  );
}

typedef InitializedRouters = (
  AuthRouter authRouter,
  MatchesRouter matchesRouter,
);
InitializedRouters getInitializedRouters({
  required InitializedControllers initializedControllers,
  required InitializedMiddlewareWrappers initializedMiddlewareWrappers,
}) {
  final (
    googleLoginController,
    getMatchController,
    createMatchController,
    logoutController,
    registerWithEmailAndPasswordController,
  ) = initializedControllers;

  final (
    requestAuthorizationMiddleware,
    matchCreateRequestMiddleware,
  ) = initializedMiddlewareWrappers;

  final authRouter = AuthRouter(
    googleLoginController: googleLoginController,
    registerWithEmailAndPasswordController:
        registerWithEmailAndPasswordController,
    logoutController: logoutController,
  );

  final matchesRouter = MatchesRouter(
    getMatchController: getMatchController,
    createMatchController: createMatchController,
    requestAuthorizationMiddleware: requestAuthorizationMiddleware,
    matchCreateRequestMiddleware: matchCreateRequestMiddleware,
  );

  return (
    authRouter,
    matchesRouter,
  );
}
