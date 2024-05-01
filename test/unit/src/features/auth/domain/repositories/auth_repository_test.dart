import 'dart:math';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/data/data_sources/auth_data_source.dart';
import '../../../../../../../bin/src/features/auth/data/entities/google_validated_id_token_response/google_validated_id_token_response_entity.dart';
import '../../../../../../../bin/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../../../bin/src/features/auth/domain/repositories/auth_repository_impl.dart';
import '../../../../../../../bin/src/features/auth/domain/values/new_auth_data_value.dart';
import '../../../../../../../bin/src/features/auth/utils/constants/auth_type_constants.dart';
import '../../../../../../../bin/src/features/auth/utils/converters/auth_converter.dart';
import '../../../../../../../bin/src/wrappers/libraries/drift/app_database.dart';
import '../../../../../../../bin/src/wrappers/local/google_apis/google_apis_wrapper.dart';

void main() {
  final authDataSource = _MockAuthDataSource();
  final googleApisWrapper = _MockGoogleApisWrapper();

  final authRepositoryImpl = AuthRepositoryImpl(
    googleApisWrapper: googleApisWrapper,
    authDataSource: authDataSource,
  );

  setUpAll(() {
    registerFallbackValue(_FakeNewAuthDataValue());
  });

  tearDown(() {
    reset(authDataSource);
    reset(googleApisWrapper);
  });

  group(
    "$AuthRepository",
    () {
      group(".register()", () {
        test(
          "given all required parameters"
          "when .register() is called "
          "then should call AuthDataSource.createAuth and return authId",
          () async {
            // setup
            when(() => authDataSource.createAuth(
                authValue: any(named: "authValue"))).thenAnswer((i) async => 1);

            // given
            final email = "email";
            final password = "password";
            final firstName = "firstName";
            final lastName = "lastName";
            final nickname = "nickname";

            // when
            final result = await authRepositoryImpl.register(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              nickname: nickname,
            );

            // then
            final expectedNewAuthEntityValue = NewAuthDataValueEmailPassword(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              nickname: nickname,
            );

            verify(
              () => authDataSource.createAuth(
                authValue: expectedNewAuthEntityValue,
              ),
            ).called(1);
            expect(result, equals(1));

            // cleanup
          },
        );
      });

      group(
        ".googleLogin()",
        () {
          test(
            "given idToken is invalid "
            "when .googleLogin() is called "
            "then should call GoogleApisWrapper.validateIdToken and return null",
            () async {
              // setup
              final idToken = "idToken";

              // given
              when(
                () => googleApisWrapper.validateIdToken(
                  idToken: any(named: "idToken"),
                ),
              ).thenAnswer((i) async => null);

              // when
              final result = await authRepositoryImpl.googleLogin(
                idToken: idToken,
              );

              // then
              verify(() => googleApisWrapper.validateIdToken(idToken: idToken))
                  .called(1);
              expect(result, null);

              // cleanup
            },
          );

          test(
            "given idToken is valid, and an auth with matching email is in database "
            "when .googleLogin() is called "
            "then should call AuthDataSource.getAuthByEmail, return authId, and NOT call AuthDataSource.createAuth",
            () async {
              // setup
              final idToken = "idToken";
              when(() => authDataSource.createAuth(
                      authValue: any(named: "authValue")))
                  .thenAnswer((i) async => 1);

              // given
              when(
                () => googleApisWrapper.validateIdToken(
                  idToken: any(named: "idToken"),
                ),
              ).thenAnswer(
                  (i) async => testGoogleApisValidatedIdTokenResponseEntity);
              when(() =>
                      authDataSource.getAuthByEmail(email: any(named: "email")))
                  .thenAnswer((invocation) async => testAuthEntityData);

              // when
              final result = await authRepositoryImpl.googleLogin(
                idToken: idToken,
              );

              // then
              verify(() => authDataSource.getAuthByEmail(
                  email: testAuthEntityData.email)).called(1);
              verifyNever(() => authDataSource.createAuth(
                  authValue: any(named: "authValue")));

              expect(result, testAuthEntityData.id);

              // cleanup
            },
          );

          test(
            "given idToken is valid, and an auth with matching email is NOT in database "
            "when .googleLogin() is called "
            "then should call AuthDataSource.getAuthByEmail, AuthDataSource.createAuth, and return authId",
            () async {
              // setup
              final idToken = "idToken";
              when(() => authDataSource.createAuth(
                      authValue: any(named: "authValue")))
                  .thenAnswer((i) async => 1);

              // given
              when(
                () => googleApisWrapper.validateIdToken(
                  idToken: any(named: "idToken"),
                ),
              ).thenAnswer(
                  (i) async => testGoogleApisValidatedIdTokenResponseEntity);
              when(() =>
                      authDataSource.getAuthByEmail(email: any(named: "email")))
                  .thenAnswer((invocation) async => null);

              // when
              final result = await authRepositoryImpl.googleLogin(
                idToken: idToken,
              );

              // then
              final expectedNewAuthEntityValue = NewAuthDataValueGoogle(
                email: testGoogleApisValidatedIdTokenResponseEntity.email,
                firstName:
                    testGoogleApisValidatedIdTokenResponseEntity.givenName,
                lastName:
                    testGoogleApisValidatedIdTokenResponseEntity.familyName,
                nickname:
                    testGoogleApisValidatedIdTokenResponseEntity.givenName,
              );

              verify(() => authDataSource.getAuthByEmail(
                  email: testAuthEntityData.email)).called(1);
              verify(
                () => authDataSource.createAuth(
                  authValue: expectedNewAuthEntityValue,
                  // authValue: any(named: "authValue"),
                ),
              ).called(1);
              expect(result, testAuthEntityData.id);

              // cleanup
            },
          );
        },
      );

      group(".getAuthByEmail()", () {
        test(
          "given email with existing auth "
          "when .getAuthByEmail() is called "
          "then should return expected auth",
          () async {
            // setup
            when(() =>
                    authDataSource.getAuthByEmail(email: any(named: "email")))
                .thenAnswer((i) async => testAuthEntityData);

            // given
            final email = "email";

            // when
            final result = await authRepositoryImpl.getAuthByEmail(
              email: email,
            );

            // then
            final expectedResult = AuthConverter.modelFromEntity(
              entity: testAuthEntityData,
            );

            expect(result, expectedResult);

            // cleanup
          },
        );

        test(
          "given email with no existing auth "
          "when .getAuthByEmail() is called "
          "then should return null",
          () async {
            // setup
            when(() =>
                    authDataSource.getAuthByEmail(email: any(named: "email")))
                .thenAnswer((i) async => null);

            // given
            final email = "email";

            // when
            final result = await authRepositoryImpl.getAuthByEmail(
              email: email,
            );

            // then
            expect(result, null);

            // cleanup
          },
        );
      });

      group(".getAuthById()", () {
        test(
          "given invalid authId "
          "when .getAuthById() is called "
          "then should return null",
          () async {
            // setup
            when(() => authDataSource.getAuthById(id: any(named: "id")))
                .thenAnswer((i) async => null);

            // given
            final authId = 1;

            // when
            final result = await authRepositoryImpl.getAuthById(
              id: authId,
            );

            // then
            expect(result, null);

            // cleanup
          },
        );

        test(
          "given valid authId "
          "when .getAuthById() is called "
          "then should return expected auth",
          () async {
            // setup
            when(() => authDataSource.getAuthById(id: any(named: "id")))
                .thenAnswer((i) async => testAuthEntityData);

            // given
            final authId = 1;

            // when
            final result = await authRepositoryImpl.getAuthById(
              id: authId,
            );

            // then
            final expectedResult = AuthConverter.modelFromEntity(
              entity: testAuthEntityData,
            );
            expect(result, expectedResult);

            // cleanup
          },
        );
      });
    },
  );
}

class _FakeNewAuthDataValue extends Fake
    implements NewAuthDataValueEmailPassword {}

class _MockAuthDataSource extends Mock implements AuthDataSource {}

class _MockGoogleApisWrapper extends Mock implements GoogleApisWrapper {}

final testGoogleApisValidatedIdTokenResponseEntity =
    GoogleApisValidatedIdTokenResponseEntity(
  iss: "iss",
  azp: "azp",
  aud: "aud",
  sub: "sub",
  email: "email",
  emailVerified: true,
  name: "name",
  picture: "picture",
  givenName: "givenName",
  familyName: "familyName",
  iat: 1,
  alg: "alg",
  exp: 1,
  kid: "kid",
  typ: "typ",
);

final testAuthEntityData = AuthEntityData(
  id: 1,
  email: "email",
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  authType: AuthTypeConstants.emailPassword.name,
  password: "password",
);
