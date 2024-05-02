import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final getAuthByEmailUseCase = _MockGetAuthByEmailUseCase();
  final request = _MockRequest();

  // tested class
  final registerWithEmailAndPasswordController =
      RegisterWithEmailAndPasswordController(
    getAuthByEmailUseCase: getAuthByEmailUseCase,
  );

  tearDown(() {
    reset(getAuthByEmailUseCase);
    reset(request);
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
      // should return expected response when user with email already exists
      test(
        "given request with email that already exists in db"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.readAsString())
              .thenAnswer((_) async => jsonEncode(requestBody));
          when(() => getAuthByEmailUseCase(email: any(named: "email")))
              .thenAnswer((_) async => _testAuthModel);

          // when
          final response = await registerWithEmailAndPasswordController.call(
            request,
          );
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "Invalid request - email already in use.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          verify(() => getAuthByEmailUseCase.call(email: requestBody["email"]!))
              .called(1);

          // cleanup
        },
      );

      // should call register use case with hashed password

      // should return expected response when player with created authId is not found

      // should return expected response when player with created authId is found

      // should return response with expected access token cookie when player with created authId is found

      // should return response with expected access token in cookie when player with created authId is found
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockGetAuthByEmailUseCase extends Mock
    implements GetAuthByEmailUseCase {}

final _testAuthModel = AuthModel(
  id: 1,
  email: "email",
  createdAt: DateTime.now().millisecondsSinceEpoch,
  updatedAt: DateTime.now().millisecondsSinceEpoch,
);
