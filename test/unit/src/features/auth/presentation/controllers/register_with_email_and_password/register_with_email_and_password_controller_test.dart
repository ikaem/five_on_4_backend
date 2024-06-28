import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/auth_response_constants.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../../../../../bin/src/features/core/utils/constants/request_constants.dart';
import '../../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final getAuthByEmailUseCase = _MockGetAuthByEmailUseCase();
  final getHashedValueUseCase = _MockGetHashedValueUseCase();
  final registerWithEmailAndPasswordUseCase =
      _MockRegisterWithEmailAndPasswordUseCase();
  final getPlayerByAuthIdUseCase = _MockGetPlayerByAuthIdUseCase();
  final createAccessJwtUseCase = _MockCreateAccessJwtUseCase();
  final createRefreshJwtCookieUseCase = _MockCreateRefreshJwtCookieUseCase();

  final request = _MockRequest();

  // tested class
  final registerWithEmailAndPasswordController =
      RegisterWithEmailAndPasswordController(
    getAuthByEmailUseCase: getAuthByEmailUseCase,
    getHashedValueUseCase: getHashedValueUseCase,
    registerWithEmailAndPasswordUseCase: registerWithEmailAndPasswordUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    createAccessJwtUseCase: createAccessJwtUseCase,
    createRefreshJwtCookieUseCase: createRefreshJwtCookieUseCase,
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  tearDown(() {
    reset(getAuthByEmailUseCase);
    reset(getHashedValueUseCase);
    reset(registerWithEmailAndPasswordUseCase);
    reset(getPlayerByAuthIdUseCase);
    reset(request);
    reset(createRefreshJwtCookieUseCase);
    reset(createAccessJwtUseCase);
  });

  group("$RegisterWithEmailAndPasswordController()", () {
    group(".call()", () {
      final requestBody = {
        "email": "email",
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
            "email",
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
            "password",
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.FIRST_NAME.value:
            "firstName",
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
            "lastName",
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
            "nickname",
      };

      test(
        "given request validation has not been done"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.context).thenReturn({});

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
            responseMessage: "Request body not validated.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given request with email that already exists in db"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => _testAuthModel);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: requestBody,
          });

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid request - email already in use.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given authId is created, but player with created authId is not found"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: requestBody,
          });
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => null);
          when(() => getHashedValueUseCase(value: any(named: "value")))
              .thenReturn("hashedPassword");
          when(() => registerWithEmailAndPasswordUseCase.call(
                email: any(named: "email"),
                hashedPassword: any(named: "hashedPassword"),
                firstName: any(named: "firstName"),
                lastName: any(named: "lastName"),
                nickname: any(named: "nickname"),
              )).thenAnswer((_) async => 1);

          // given
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((_) async => null);

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
            responseMessage: "Authenticated player not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given a valid request "
        "when .call() is called"
        "then should call RegisterWithEmailAndPasswordUseCase.call with expected arguments",
        () async {
          // setup
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => null);
          when(() => getHashedValueUseCase(value: any(named: "value")))
              .thenReturn("hashedPassword");
          when(() => registerWithEmailAndPasswordUseCase.call(
                email: any(named: "email"),
                hashedPassword: any(named: "hashedPassword"),
                firstName: any(named: "firstName"),
                lastName: any(named: "lastName"),
                nickname: any(named: "nickname"),
              )).thenAnswer((_) async => 1);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((_) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(
            () => createRefreshJwtCookieUseCase.call(
              authId: any(named: "authId"),
              playerId: any(named: "playerId"),
            ),
          ).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: requestBody,
          });

          // when
          await registerWithEmailAndPasswordController.call(
            request,
          );

          verify(() => registerWithEmailAndPasswordUseCase.call(
                email: requestBody[
                    RegisterWithEmailAndPasswordRequestBodyKeyConstants
                        .EMAIL.value]!,
                hashedPassword: "hashedPassword",
                firstName: requestBody[
                    RegisterWithEmailAndPasswordRequestBodyKeyConstants
                        .FIRST_NAME.value]!,
                lastName: requestBody[
                    RegisterWithEmailAndPasswordRequestBodyKeyConstants
                        .LAST_NAME.value]!,
                nickname: requestBody[
                    RegisterWithEmailAndPasswordRequestBodyKeyConstants
                        .NICKNAME.value]!,
              )).called(1);

          // cleanup
        },
      );

      test(
        "given valid request"
        "when call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => null);
          when(() => getHashedValueUseCase(value: any(named: "value")))
              .thenReturn("hashedPassword");
          when(() => registerWithEmailAndPasswordUseCase.call(
                email: any(named: "email"),
                hashedPassword: any(named: "hashedPassword"),
                firstName: any(named: "firstName"),
                lastName: any(named: "lastName"),
                nickname: any(named: "nickname"),
              )).thenAnswer((_) async => 1);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((_) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(
            () => createRefreshJwtCookieUseCase.call(
              authId: any(named: "authId"),
              playerId: any(named: "playerId"),
            ),
          ).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: requestBody,
          });

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );
          final responseString = await response.readAsString();

          // then
          final expectedResponseData = {
            "id": _testPlayerModel.id,
            "name": _testPlayerModel.name,
            "nickname": _testPlayerModel.nickname,
          };
          final expectedResponse = generateTestOkResponse(
            responseData: expectedResponseData,
            responseMessage: "User registered successfully",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given valid request"
        "when call() is called"
        "then should return response with expected access jwt in headers",
        () async {
          // setup
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => null);
          when(() => getHashedValueUseCase(value: any(named: "value")))
              .thenReturn("hashedPassword");
          when(() => registerWithEmailAndPasswordUseCase.call(
                email: any(named: "email"),
                hashedPassword: any(named: "hashedPassword"),
                firstName: any(named: "firstName"),
                lastName: any(named: "lastName"),
                nickname: any(named: "nickname"),
              )).thenAnswer((_) async => 1);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((_) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(
            () => createRefreshJwtCookieUseCase.call(
              authId: any(named: "authId"),
              playerId: any(named: "playerId"),
            ),
          ).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: requestBody,
          });

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );

          // then
          final accessToken = response
              .headers[AuthResponseConstants.ACCESS_JWT_HEADER_KEY.value];
          expect(accessToken, equals("jwt"));

          // cleanup
        },
      );

      test(
        "given valid request"
        "when call() is called"
        "then should return response with expected refresh jwt in cookie",
        () async {
          // setup
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => null);
          when(() => getHashedValueUseCase(value: any(named: "value")))
              .thenReturn("hashedPassword");
          when(() => registerWithEmailAndPasswordUseCase.call(
                email: any(named: "email"),
                hashedPassword: any(named: "hashedPassword"),
                firstName: any(named: "firstName"),
                lastName: any(named: "lastName"),
                nickname: any(named: "nickname"),
              )).thenAnswer((_) async => 1);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((_) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(
            () => createRefreshJwtCookieUseCase.call(
              authId: any(named: "authId"),
              playerId: any(named: "playerId"),
            ),
          ).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: requestBody,
          });

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );

          // then
          final responsCookies = response.headers[HttpHeaders.setCookieHeader];

          final cookieStrings = responsCookies!.split(",");
          final cookies = cookieStrings.map((cookieString) {
            return Cookie.fromSetCookieValue(cookieString);
          }).toList();

          expect(cookies, hasLength(1));
          expect(
              cookies.first.toString(), equals(_testRefreshCookie.toString()));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockGetAuthByEmailUseCase extends Mock
    implements GetAuthByEmailUseCase {}

class _MockGetHashedValueUseCase extends Mock
    implements GetHashedValueUseCase {}

class _MockGetPlayerByAuthIdUseCase extends Mock
    implements GetPlayerByAuthIdUseCase {}

class _MockRegisterWithEmailAndPasswordUseCase extends Mock
    implements RegisterWithEmailAndPasswordUseCase {}

class _MockCreateAccessJwtUseCase extends Mock
    implements CreateAccessJwtUseCase {}

class _MockCreateRefreshJwtCookieUseCase extends Mock
    implements CreateRefreshJwtCookieUseCase {}

final _testAuthModel = AuthModel(
  id: 1,
  email: "email",
  createdAt: DateTime.now().millisecondsSinceEpoch,
  updatedAt: DateTime.now().millisecondsSinceEpoch,
);

final _testPlayerModel = PlayerModel(
  id: 1,
  authId: 1,
  nickname: "nickname",
  name: "name",
);

final _testRefreshCookie = Cookie.fromSetCookieValue(
  "refresh_token=token; HttpOnly; Secure; Path=/",
);
