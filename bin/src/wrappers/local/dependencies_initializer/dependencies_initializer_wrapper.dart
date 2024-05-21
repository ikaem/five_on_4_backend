import 'dart:developer';

import 'package:dio/dio.dart' hide Response;

import '../../../features/auth/data/data_sources/auth_data_source_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../features/auth/domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';
import '../../../features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../features/auth/presentation/controllers/login/login_controller.dart';
import '../../../features/auth/presentation/controllers/logout/logout_controller.dart';
import '../../../features/auth/presentation/controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';
import '../../../features/auth/presentation/router/auth_router.dart';
import '../../../features/auth/utils/middlewares/authenticate_with_google_request_middleware_wrapper.dart';
import '../../../features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import '../../../features/auth/utils/middlewares/login_request_middleware_wrapper.dart';
import '../../../features/auth/utils/middlewares/register_with_email_and_password_request_middleware_wrapper.dart';
import '../../../features/auth/utils/validators/authenticate_with_google_request_validator.dart';
import '../../../features/auth/utils/validators/authorize_request_validator.dart';
import '../../../features/auth/utils/validators/login_request_validator.dart';
import '../../../features/auth/utils/validators/register_with_email_and_password_request_validator.dart';
import '../../../features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../features/core/domain/use_cases/get_authorization_bearer_token_from_request_headers/get_authorization_bearer_token_from_request_headers_use_case.dart';
import '../../../features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../features/core/presentation/router/app_router.dart';
import '../../../features/matches/data/data_sources/matches_data_source_impl.dart';
import '../../../features/matches/domain/repositories/matches_repository_impl.dart';
import '../../../features/matches/domain/use_cases/create_match/create_match_use_case.dart';
import '../../../features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../features/matches/presentation/controllers/create_match_controller.dart';
import '../../../features/matches/presentation/controllers/get_match_controller.dart';
import '../../../features/matches/presentation/router/matches_router.dart';
import '../../../features/matches/utils/middlewares/match_create_request_middleware_wrapper.dart';
import '../../../features/matches/utils/validators/match_create_request_validator.dart';
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
import 'dependencies_values.dart';

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
        // initializedWrappers: initializedWrappers,
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

    final AppRouter appRouter = AppRouter(
      authRouter: initializedRouters.authRouter,
      matchesRouter: initializedRouters.matchesRouter,
    );
    _appRouter = appRouter;
  }
}

InitializedWrappersDependenciesValues getInitializedWrappers({
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

  return InitializedWrappersDependenciesValues(
    dioWrapper: dioWrapper,
    dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
    googleApisWrapper: googleApisWrapper,
    cryptWrapper: cryptWrapper,
    cookiesHandlerWrapper: cookiesHandlerWrapper,
  );
}

InitializedDataSourcesDependenciesValues getInitializedDataSources({
  required DatabaseWrapper databaseWrapper,
}) {
  final authDataSource = AuthDataSourceImpl(
    databaseWrapper: databaseWrapper,
  );
  final playersDataSource = PlayersDataSourceImpl(
    databaseWrapper: databaseWrapper,
  );
  final matchesDataSource =
      MatchesDataSourceImpl(databaseWrapper: databaseWrapper);

  return InitializedDataSourcesDependenciesValues(
    authDataSource: authDataSource,
    playersDataSource: playersDataSource,
    matchesDataSource: matchesDataSource,
  );
}

InitializedRepositoriesDependenciesValues getInitializedRepositories({
  required InitializedDataSourcesDependenciesValues initializedDataSources,
  required InitializedWrappersDependenciesValues initializedWrappers,
}) {
  final authRepository = AuthRepositoryImpl(
    authDataSource: initializedDataSources.authDataSource,
    googleApisWrapper: initializedWrappers.googleApisWrapper,
  );

  final playersRepository = PlayersRepositoryImpl(
    playersDataSource: initializedDataSources.playersDataSource,
  );

  final matchesRepository = MatchesRepositoryImpl(
    matchesDataSource: initializedDataSources.matchesDataSource,
  );

  return InitializedRepositoriesDependenciesValues(
    authRepository: authRepository,
    playersRepository: playersRepository,
    matchesRepository: matchesRepository,
  );
}

InitializedUseCasesDependenciesValues getInitializedUseCases({
  required InitializedRepositoriesDependenciesValues initializedRepositories,
  required InitializedWrappersDependenciesValues initializedWrappers,
}) {
  final googleLoginUseCase = GoogleLoginUseCase(
    authRepository: initializedRepositories.authRepository,
  );
  final getPlayerByAuthIdUseCase = GetPlayerByAuthIdUseCase(
    playersRepository: initializedRepositories.playersRepository,
  );

  final getMatchUseCase = GetMatchUseCase(
    matchesRepository: initializedRepositories.matchesRepository,
  );
  final getPlayerByIdUseCase = GetPlayerByIdUseCase(
    playersRepository: initializedRepositories.playersRepository,
  );
  final getAuthByIdUseCase = GetAuthByIdUseCase(
    authRepository: initializedRepositories.authRepository,
  );
  final getCookieByNameInStringUseCase = GetCookieByNameInStringUseCase(
    cookiesHandlerWrapper: initializedWrappers.cookiesHandlerWrapper,
  );
  final getAccessTokenDataFromAccessJwtUseCase =
      GetAccessTokenDataFromAccessJwtUseCase(
    dartJsonWebTokenWrapper: initializedWrappers.dartJsonWebTokenWrapper,
  );
  final createMatchUseCase = CreateMatchUseCase(
    matchesRepository: initializedRepositories.matchesRepository,
  );
  final getAuthByEmailUseCase = GetAuthByEmailUseCase(
    authRepository: initializedRepositories.authRepository,
  );
  final getHashedValueUseCase = GetHashedValueUseCase(
    cryptWrapper: initializedWrappers.cryptWrapper,
  );
  final registerWithEmailAndPasswordUseCase =
      RegisterWithEmailAndPasswordUseCase(
    authRepository: initializedRepositories.authRepository,
  );
  final getAuthByEmailAndHashedPasswordUseCase =
      GetAuthByEmailAndHashedPasswordUseCase(
    authRepository: initializedRepositories.authRepository,
  );
  final getAuthorizationBearerTokenFromRequestHeadersUseCase =
      GetAuthorizationBearerTokenFromRequestHeadersUseCase();
  final createAccessJwtUseCase = CreateAccessJwtUseCase(
    dartJsonWebTokenWrapper: initializedWrappers.dartJsonWebTokenWrapper,
  );
  final createRefreshJwtCookieUseCase = CreateRefreshJwtCookieUseCase(
    dartJsonWebTokenWrapper: initializedWrappers.dartJsonWebTokenWrapper,
  );

  return InitializedUseCasesDependenciesValues(
    googleLoginUseCase: googleLoginUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    getMatchUseCase: getMatchUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
    createMatchUseCase: createMatchUseCase,
    getAuthByEmailUseCase: getAuthByEmailUseCase,
    getHashedValueUseCase: getHashedValueUseCase,
    registerWithEmailAndPasswordUseCase: registerWithEmailAndPasswordUseCase,
    getAuthByEmailAndHashedPasswordUseCase:
        getAuthByEmailAndHashedPasswordUseCase,
    getAuthorizationBearerTokenFromRequestHeadersUseCase:
        getAuthorizationBearerTokenFromRequestHeadersUseCase,
    createAccessJwtUseCase: createAccessJwtUseCase,
    createRefreshJwtCookieUseCase: createRefreshJwtCookieUseCase,
  );
}

InitialiazedControllersDependenciesValues getInitializedControllers({
  required InitializedUseCasesDependenciesValues initializedUseCases,
}) {
  final googleLoginController = GoogleLoginController(
    googleLoginUseCase: initializedUseCases.googleLoginUseCase,
    getPlayerByAuthIdUseCase: initializedUseCases.getPlayerByAuthIdUseCase,
    createAccessJwtUseCase: initializedUseCases.createAccessJwtUseCase,
    createRefreshJwtCookieUseCase:
        initializedUseCases.createRefreshJwtCookieUseCase,
  );
  final getMatchController = GetMatchController(
    getMatchUseCase: initializedUseCases.getMatchUseCase,
  );
  final createMatchController = CreateMatchController(
    createMatchUseCase: initializedUseCases.createMatchUseCase,
  );
  final logoutController = LogoutController();

  final registerWithEmailAndPasswordController =
      RegisterWithEmailAndPasswordController(
    getAuthByEmailUseCase: initializedUseCases.getAuthByEmailUseCase,
    getHashedValueUseCase: initializedUseCases.getHashedValueUseCase,
    registerWithEmailAndPasswordUseCase:
        initializedUseCases.registerWithEmailAndPasswordUseCase,
    getPlayerByAuthIdUseCase: initializedUseCases.getPlayerByAuthIdUseCase,
    createAccessJwtUseCase: initializedUseCases.createAccessJwtUseCase,
    createRefreshJwtCookieUseCase:
        initializedUseCases.createRefreshJwtCookieUseCase,
  );

  final loginController = LoginController(
    getAuthByEmailAndHashedPasswordUseCase:
        initializedUseCases.getAuthByEmailAndHashedPasswordUseCase,
    getPlayerByAuthIdUseCase: initializedUseCases.getPlayerByAuthIdUseCase,
    getHashedValueUseCase: initializedUseCases.getHashedValueUseCase,
    createAccessJwtUseCase: initializedUseCases.createAccessJwtUseCase,
    createRefreshJwtCookieUseCase:
        initializedUseCases.createRefreshJwtCookieUseCase,
  );

  return InitialiazedControllersDependenciesValues(
    googleLoginController: googleLoginController,
    getMatchController: getMatchController,
    createMatchController: createMatchController,
    logoutController: logoutController,
    registerWithEmailAndPasswordController:
        registerWithEmailAndPasswordController,
    loginController: loginController,
  );
}

InitializedValidatorsDependenciesValues getInitializedValidators({
  required InitializedUseCasesDependenciesValues initializedUseCases,
}) {
  final requestAuthorizationValidator = AuthorizeRequestValidator(
    getAccessTokenDataFromAccessJwtUseCase:
        initializedUseCases.getAccessTokenDataFromAccessJwtUseCase,
    getPlayerByIdUseCase: initializedUseCases.getPlayerByIdUseCase,
    getAuthByIdUseCase: initializedUseCases.getAuthByIdUseCase,
    getAuthorizationBearerTokenFromRequestHeadersUseCase: initializedUseCases
        .getAuthorizationBearerTokenFromRequestHeadersUseCase,
  );
  final matchCreateRequestValidator = MatchCreateRequestValidator();
  final loginRequestValidator = LoginRequestValidator();
  final registerWithEmailAndPasswordRequestValidator =
      RegisterWithEmailAndPasswordRequestValidator();
  final authenticateWithGoogleRequestValidator =
      AuthenticateWithGoogleRequestValidator();

  return InitializedValidatorsDependenciesValues(
    requestAuthorizationValidator: requestAuthorizationValidator,
    matchCreateRequestValidator: matchCreateRequestValidator,
    loginRequestValidator: loginRequestValidator,
    registerWithEmailAndPasswordRequestValidator:
        registerWithEmailAndPasswordRequestValidator,
    authenticateWithGoogleRequestValidator:
        authenticateWithGoogleRequestValidator,
  );
}

InitializedMiddlewareWrappersDependenciesValues
    getInitializedMiddlewareWrappers({
  required InitializedValidatorsDependenciesValues initializedValidators,
}) {
  final requestAuthorizationMiddleware = AuthorizeRequestMiddlewareWrapper(
    authorizeRequestValidator:
        initializedValidators.requestAuthorizationValidator,
  );
  final matchCreateRequestMiddleware = MatchCreateRequestMiddlewareWrapper(
    matchCreateRequestValidator:
        initializedValidators.matchCreateRequestValidator,
  );
  final registerWithEmailAndPasswordRequestMiddleware =
      RegisterWithEmailAndPasswordRequestMiddlewareWrapper(
    registerWithEmailAndPasswordRequestValidator:
        initializedValidators.registerWithEmailAndPasswordRequestValidator,
  );
  final loginRequestMiddlewareWrapper = LoginRequestMiddlewareWrapper(
    loginRequestValidator: initializedValidators.loginRequestValidator,
  );
  final authenticateWithGoogleRequestMiddlewareWrapper =
      AuthenticateWithGoogleRequestMiddlewareWrapper(
    authenticateWithGoogleRequestValidator:
        initializedValidators.authenticateWithGoogleRequestValidator,
  );

  return InitializedMiddlewareWrappersDependenciesValues(
    authorizeRequestMiddlewareWrapper: requestAuthorizationMiddleware,
    loginRequestMiddlewareWrapper: loginRequestMiddlewareWrapper,
    matchCreateRequestMiddlewareWrapper: matchCreateRequestMiddleware,
    registerWithEmailAndPasswordRequestMiddlewareWrapper:
        registerWithEmailAndPasswordRequestMiddleware,
    authenticateWithGoogleRequestMiddlewareWrapper:
        authenticateWithGoogleRequestMiddlewareWrapper,
  );
}

InitializedRoutersDependenciesValues getInitializedRouters({
  required InitialiazedControllersDependenciesValues initializedControllers,
  required InitializedMiddlewareWrappersDependenciesValues
      initializedMiddlewareWrappers,
}) {
  final authRouter = AuthRouter(
    googleLoginController: initializedControllers.googleLoginController,
    registerWithEmailAndPasswordController:
        initializedControllers.registerWithEmailAndPasswordController,
    logoutController: initializedControllers.logoutController,
    loginController: initializedControllers.loginController,
    authorizeRequestMiddlewareWrapper:
        initializedMiddlewareWrappers.authorizeRequestMiddlewareWrapper,
    registerWithEmailAndPasswordRequestMiddlewareWrapper:
        initializedMiddlewareWrappers
            .registerWithEmailAndPasswordRequestMiddlewareWrapper,
    loginRequestMiddlewareWrapper:
        initializedMiddlewareWrappers.loginRequestMiddlewareWrapper,
    authenticateWithGoogleRequestMiddlewareWrapper:
        initializedMiddlewareWrappers
            .authenticateWithGoogleRequestMiddlewareWrapper,
  );

  final matchesRouter = MatchesRouter(
    getMatchController: initializedControllers.getMatchController,
    createMatchController: initializedControllers.createMatchController,
    requestAuthorizationMiddleware:
        initializedMiddlewareWrappers.authorizeRequestMiddlewareWrapper,
    matchCreateRequestMiddleware:
        initializedMiddlewareWrappers.matchCreateRequestMiddlewareWrapper,
  );

  return InitializedRoutersDependenciesValues(
    authRouter: authRouter,
    matchesRouter: matchesRouter,
  );
}
