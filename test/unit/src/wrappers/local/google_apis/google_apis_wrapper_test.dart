import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/data/entities/google_validated_id_token_response/google_validated_id_token_response_entity.dart';
import 'package:five_on_4_backend/src/features/core/domain/values/http_request_value.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/dio/dio_wrapper.dart';
import 'package:five_on_4_backend/src/wrappers/local/google_apis/google_apis_wrapper.dart';

void main() {
  final dioWrapper = _MockDioWrapper();

  final googleApisWrapper = GoogleApisWrapper(
    dioWrapper: dioWrapper,
  );

  setUpAll(() {
    registerFallbackValue(_FakeHttpRequestUriPartsValue());
  });

  tearDown(() {
    reset(dioWrapper);
  });

  group(
    "$GoogleApisWrapper",
    () {
      test(
        "given an invalid token "
        "when .validateIdToken() is called "
        "then should return null",
        () async {
          // setup

          // given
          when(() => dioWrapper.get<Map<String, dynamic>>(
                uriParts: any(named: 'uriParts'),
              )).thenAnswer((invocation) async {
            return {
              'not_expected_field': 'bad response',
            };
          });

          // when
          final response = await googleApisWrapper.validateIdToken(
            idToken: 'invalid_token',
          );

          // then
          expect(response, isNull);

          // cleanup
        },
      );

      test(
        "given a valid token "
        "when .validateIdToken() is called "
        "then should return expected GoogleApisValidatedIdTokenResponseEntity",
        () async {
          // setup
          final jsonMap = {
            'iss': 'iss',
            'azp': 'azp',
            'aud': 'aud',
            'sub': 'sub',
            'email': 'email',
            'email_verified': 'true',
            'name': 'name',
            'picture': 'picture',
            'given_name': 'given_name',
            'family_name': 'family_name',
            'iat': "1",
            'exp': "2",
            'alg': 'alg',
            'kid': 'kid',
            'typ': 'typ',
          };

          // given
          when(() => dioWrapper.get<Map<String, dynamic>>(
                uriParts: any(named: 'uriParts'),
              )).thenAnswer((invocation) async {
            return jsonMap;
          });

          // when
          final response = await googleApisWrapper.validateIdToken(
            idToken: 'valid_token',
          );

          // then
          final expected = _createGoogleApisValidatedIdTokenResponseEntity(
            jsonMap: jsonMap,
          );
          expect(response, equals(expected));

          // cleanup
        },
      );
    },
  );
}

class _FakeHttpRequestUriPartsValue extends Fake
    implements HttpRequestUriPartsValue {}

class _MockDioWrapper extends Mock implements DioWrapper {}

GoogleApisValidatedIdTokenResponseEntity
    _createGoogleApisValidatedIdTokenResponseEntity({
  required Map<String, dynamic> jsonMap,
}) {
  return GoogleApisValidatedIdTokenResponseEntity(
    iss: jsonMap['iss'] as String,
    azp: jsonMap['azp'] as String,
    aud: jsonMap['aud'] as String,
    sub: jsonMap['sub'] as String,
    email: jsonMap['email'] as String,
    emailVerified: (jsonMap['email_verified'] as String) == 'true',
    name: jsonMap['name'] as String,
    picture: jsonMap['picture'] as String,
    givenName: jsonMap['given_name'] as String,
    familyName: jsonMap['family_name'] as String,
    iat: int.tryParse(jsonMap['iat'] as String) ?? 0,
    exp: int.tryParse(jsonMap['exp'] as String) ?? 0,
    alg: jsonMap['alg'] as String,
    kid: jsonMap['kid'] as String,
    typ: jsonMap['typ'] as String,
  );
}
