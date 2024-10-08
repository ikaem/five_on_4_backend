import 'package:five_on_4_backend/src/features/matches/domain/use_cases/search_matches/search_matches_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
import 'package:five_on_4_backend/src/features/matches/utils/middlewares/search_matches_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/utils/validators/search_matches_request_validator.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/data_sources/player_match_participations_data_source.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/repositories/player_match_participations_repository.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/dont_join_match/dont_join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/invite_to_match/invite_to_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/join_match/join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/controllers/store_player_match_participation_controller.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/router/player_match_participation_router.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/middlewares/store_player_match_participation_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/validators/store_player_match_participate_request_validator.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/search_players/search_players_use_case.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/get_player_controller.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/search_players_controller.dart';
import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/get_player_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/search_players_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/get_player_request_validator.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/search_players_request_validator.dart';

import '../../../features/auth/data/data_sources/auth_data_source.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../features/auth/domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';
import '../../../features/auth/presentation/controllers/get_auth/get_auth_controller.dart';
import '../../../features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../features/auth/presentation/controllers/login/login_controller.dart';
import '../../../features/auth/presentation/controllers/logout/logout_controller.dart';
import '../../../features/auth/presentation/controllers/refresh_token/refresh_token_controller.dart';
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
import '../../../features/core/domain/use_cases/get_authorization_bearer_token_from_request/get_authorization_bearer_token_from_request_use_case.dart';
import '../../../features/core/domain/use_cases/get_cookie_by_name_in_request/get_cookie_by_name_in_request_use_case.dart';
import '../../../features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../features/core/domain/use_cases/get_refresh_token_data_from_access_jwt/get_refresh_token_data_from_access_jwt_use_case.dart';
import '../../../features/matches/data/data_sources/matches_data_source.dart';
import '../../../features/matches/domain/repositories/matches_repository.dart';
import '../../../features/matches/domain/use_cases/create_match/create_match_use_case.dart';
import '../../../features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../features/matches/domain/use_cases/get_player_matches_overview/get_player_matches_overview_use_case.dart';
import '../../../features/matches/presentation/controllers/create_match_controller.dart';
import '../../../features/matches/presentation/controllers/get_match_controller.dart';
import '../../../features/matches/presentation/controllers/get_player_matches_overview_controller.dart';
import '../../../features/matches/presentation/router/matches_router.dart';
import '../../../features/matches/utils/middlewares/get_player_matches_overview_request_middleware_wrapper.dart';
import '../../../features/matches/utils/middlewares/match_create_request_middleware_wrapper.dart';
import '../../../features/matches/utils/validators/get_player_matches_overview_request_validator.dart';
import '../../../features/matches/utils/validators/match_create_request_validator.dart';
import '../../../features/players/data/data_sources/players_data_source.dart';
import '../../../features/players/domain/repositories/players_repository.dart';
import '../../../features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../libraries/crypt/crypt_wrapper.dart';
import '../../libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../libraries/dio/dio_wrapper.dart';
import '../cookies_handler/cookies_handler_wrapper.dart';
import '../google_apis/google_apis_wrapper.dart';

// TODO this should probably be tested
class InitializedWrappersDependenciesValues {
  const InitializedWrappersDependenciesValues({
    required this.dioWrapper,
    required this.dartJsonWebTokenWrapper,
    required this.googleApisWrapper,
    required this.cryptWrapper,
    required this.cookiesHandlerWrapper,
  });

  final DioWrapper dioWrapper;
  final DartJsonWebTokenWrapper dartJsonWebTokenWrapper;
  final GoogleApisWrapper googleApisWrapper;
  final CryptWrapper cryptWrapper;
  final CookiesHandlerWrapper cookiesHandlerWrapper;
}

class InitializedDataSourcesDependenciesValues {
  const InitializedDataSourcesDependenciesValues({
    required this.authDataSource,
    required this.playersDataSource,
    required this.matchesDataSource,
    required this.playerMatchParticipationsDataSource,
  });

  final AuthDataSource authDataSource;
  final PlayersDataSource playersDataSource;
  final MatchesDataSource matchesDataSource;
  final PlayerMatchParticipationsDataSource playerMatchParticipationsDataSource;
}

class InitializedRepositoriesDependenciesValues {
  const InitializedRepositoriesDependenciesValues({
    required this.authRepository,
    required this.playersRepository,
    required this.matchesRepository,
    required this.playerMatchParticipationsRepository,
  });

  final AuthRepository authRepository;
  final PlayersRepository playersRepository;
  final MatchesRepository matchesRepository;
  final PlayerMatchParticipationsRepository playerMatchParticipationsRepository;
}

class InitializedUseCasesDependenciesValues {
  const InitializedUseCasesDependenciesValues({
    required this.getAuthByEmailUseCase,
    required this.getAuthByIdUseCase,
    required this.getAuthByEmailAndHashedPasswordUseCase,
    required this.registerWithEmailAndPasswordUseCase,
    required this.googleLoginUseCase,
    required this.getPlayerByAuthIdUseCase,
    required this.getMatchUseCase,
    required this.getPlayerByIdUseCase,
    required this.getCookieByNameInStringUseCase,
    required this.getAccessTokenDataFromAccessJwtUseCase,
    required this.createMatchUseCase,
    required this.getHashedValueUseCase,
    required this.getAuthorizationBearerTokenFromRequestHeadersUseCase,
    required this.createAccessJwtUseCase,
    required this.createRefreshJwtCookieUseCase,
    required this.getRefreshTokenDataFromAccessJwtUseCase,
    required this.getPlayerMatchesOverviewUseCase,
    required this.searchMatchesUseCase,
    required this.searchPlayersUseCase,
    required this.joinMatchUseCase,
    required this.dontJoinMatchUseCase,
    required this.inviteToMatchUseCase,
  });

  final GoogleLoginUseCase googleLoginUseCase;
  final GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase;
  final GetMatchUseCase getMatchUseCase;
  final GetPlayerByIdUseCase getPlayerByIdUseCase;
  final GetAuthByIdUseCase getAuthByIdUseCase;
  final GetCookieByNameInRequestUseCase getCookieByNameInStringUseCase;
  final GetAccessTokenDataFromAccessJwtUseCase
      getAccessTokenDataFromAccessJwtUseCase;
  final CreateMatchUseCase createMatchUseCase;
  final GetAuthByEmailUseCase getAuthByEmailUseCase;
  final GetHashedValueUseCase getHashedValueUseCase;
  final RegisterWithEmailAndPasswordUseCase registerWithEmailAndPasswordUseCase;
  final GetAuthByEmailAndHashedPasswordUseCase
      getAuthByEmailAndHashedPasswordUseCase;
  final GetAuthorizationBearerTokenFromRequestHeadersUseCase
      getAuthorizationBearerTokenFromRequestHeadersUseCase;
  final CreateAccessJwtUseCase createAccessJwtUseCase;
  final CreateRefreshJwtCookieUseCase createRefreshJwtCookieUseCase;
  final GetRefreshTokenDataFromAccessJwtUseCase
      getRefreshTokenDataFromAccessJwtUseCase;
  final GetPlayerMatchesOverviewUseCase getPlayerMatchesOverviewUseCase;
  final SearchMatchesUseCase searchMatchesUseCase;
  final SearchPlayersUseCase searchPlayersUseCase;
  final JoinMatchUseCase joinMatchUseCase;
  final DontJoinMatchUseCase dontJoinMatchUseCase;
  final InviteToMatchUseCase inviteToMatchUseCase;
}

class InitialiazedControllersDependenciesValues {
  const InitialiazedControllersDependenciesValues({
    required this.loginController,
    required this.registerWithEmailAndPasswordController,
    required this.logoutController,
    required this.googleLoginController,
    required this.getMatchController,
    required this.createMatchController,
    required this.getAuthController,
    required this.refreshTokenController,
    required this.getPlayerMatchesOverviewController,
    required this.searchMatchesController,
    required this.searchPlayersController,
    required this.getPlayerController,
    required this.storePlayerMatchParticipationController,
  });

  final LoginController loginController;
  final RegisterWithEmailAndPasswordController
      registerWithEmailAndPasswordController;
  final LogoutController logoutController;
  final GoogleLoginController googleLoginController;
  final GetMatchController getMatchController;
  final CreateMatchController createMatchController;
  final GetAuthController getAuthController;
  final RefreshTokenController refreshTokenController;
  final GetPlayerMatchesOverviewController getPlayerMatchesOverviewController;
  final SearchMatchesController searchMatchesController;
  final SearchPlayersController searchPlayersController;
  final GetPlayerController getPlayerController;
  final StorePlayerMatchParticipationController
      storePlayerMatchParticipationController;
}

class InitializedValidatorsDependenciesValues {
  const InitializedValidatorsDependenciesValues({
    required this.requestAuthorizationValidator,
    required this.matchCreateRequestValidator,
    required this.loginRequestValidator,
    required this.registerWithEmailAndPasswordRequestValidator,
    required this.authenticateWithGoogleRequestValidator,
    required this.getPlayerMatchesOverviewRequestValidator,
    required this.searchMatchesRequestValidator,
    required this.searchPlayersRequestValidator,
    required this.getPlayerRequestValidator,
    required this.storePlayerMatchParticipateRequestValidator,
  });

  final AuthorizeRequestValidator requestAuthorizationValidator;
  final MatchCreateRequestValidator matchCreateRequestValidator;
  final LoginRequestValidator loginRequestValidator;
  final RegisterWithEmailAndPasswordRequestValidator
      registerWithEmailAndPasswordRequestValidator;
  final AuthenticateWithGoogleRequestValidator
      authenticateWithGoogleRequestValidator;
  final GetPlayerMatchesOverviewRequestValidator
      getPlayerMatchesOverviewRequestValidator;
  final SearchMatchesRequestValidator searchMatchesRequestValidator;
  final SearchPlayersRequestValidator searchPlayersRequestValidator;
  final GetPlayerRequestValidator getPlayerRequestValidator;
  final StorePlayerMatchParticipateRequestValidator
      storePlayerMatchParticipateRequestValidator;
}

class InitializedMiddlewareWrappersDependenciesValues {
  const InitializedMiddlewareWrappersDependenciesValues({
    required this.authorizeRequestMiddlewareWrapper,
    required this.loginRequestMiddlewareWrapper,
    required this.matchCreateRequestMiddlewareWrapper,
    required this.registerWithEmailAndPasswordRequestMiddlewareWrapper,
    required this.authenticateWithGoogleRequestMiddlewareWrapper,
    required this.getPlayerMatchesOverviewRequestMiddlewareWrapper,
    required this.searchMatchesRequestMiddlewareWrapper,
    required this.searchPlayersMiddlewareWrapper,
    required this.getPlayerRequestMiddlewareWrapper,
    required this.storePlayerMatchParticipationRequestMiddlewareWrapper,
  });

  final AuthorizeRequestMiddlewareWrapper authorizeRequestMiddlewareWrapper;
  final LoginRequestMiddlewareWrapper loginRequestMiddlewareWrapper;
  final MatchCreateRequestMiddlewareWrapper matchCreateRequestMiddlewareWrapper;
  final RegisterWithEmailAndPasswordRequestMiddlewareWrapper
      registerWithEmailAndPasswordRequestMiddlewareWrapper;
  final AuthenticateWithGoogleRequestMiddlewareWrapper
      authenticateWithGoogleRequestMiddlewareWrapper;
  final GetPlayerMatchesOverviewRequestMiddlewareWrapper
      getPlayerMatchesOverviewRequestMiddlewareWrapper;
  final SearchMatchesRequestMiddlewareWrapper
      searchMatchesRequestMiddlewareWrapper;
  final SearchPlayersRequestMiddlewareWrapper searchPlayersMiddlewareWrapper;
  final GetPlayerRequestMiddlewareWrapper getPlayerRequestMiddlewareWrapper;
  final StorePlayerMatchParticipationRequestMiddlewareWrapper
      storePlayerMatchParticipationRequestMiddlewareWrapper;
}

class InitializedRoutersDependenciesValues {
  const InitializedRoutersDependenciesValues({
    required this.authRouter,
    required this.matchesRouter,
    required this.playersRouter,
    required this.playerMatchParticipationRouter,
  });

  final AuthRouter authRouter;
  final MatchesRouter matchesRouter;
  final PlayersRouter playersRouter;
  final PlayerMatchParticipationRouter playerMatchParticipationRouter;
}
