import '../../../features/auth/data/entities/google_validated_id_token_response/google_validated_id_token_response_entity.dart';
import '../../../features/core/presentation/router/domain/values/http_request_value.dart';
import '../../../features/core/utils/constants/http_constants.dart';
import '../../libraries/dio/dio_wrapper.dart';

part 'constants.dart';

class GoogleApisWrapper {
  const GoogleApisWrapper({
    required DioWrapper dioWrapper,
  }) : _dioWrapper = dioWrapper;

  final DioWrapper _dioWrapper;

  Future<GoogleApisValidatedIdTokenResponseEntity?> validateIdToken({
    required String idToken,
  }) async {
    final response = await _dioWrapper.get<Map<String, dynamic>>(
      uriParts: HttpRequestUriPartsValue(
        apiUrlScheme: HttpConstants.HTTPS_PROTOCOL.value,
        apiBaseUrl: GoogleApisHttpConstants.BASE_URL.value,
        apiContextPath: GoogleApisHttpConstants.OAUTH_API_CONTEXT_PATH.value,
        apiEndpointPath:
            GoogleApisHttpConstants.OAUTH_TOKEN_INFO_API_ENDPOINT_PATH.value,
        queryParameters: {
          'id_token': idToken,
        },
      ),
    );

    final isValid = _checkIsValidateIdTokenResponseValid(response: response);
    if (!isValid) {
      return null;
    }

    final entity =
        GoogleApisValidatedIdTokenResponseEntity.fromJson(json: response);

    return entity;
  }

  // String get url => HttpConstants

  // https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=XYZ123
  // https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${access_token}
}

// Expected this library to be part of 'file:///Users/karlo/development/mine/servers_dart_testing/drift_server/bin/src/wrappers/local/google_id_token_validator/google_id_token_validator_wrapper.dart', not 'file:///Users/karlo/development/mine/servers_dart_testing/drift_server/bin/src/wrappers/local/google_id_token_validator/constants.dart'.

bool _checkIsValidateIdTokenResponseValid({
  required Map<String, dynamic> response,
}) {
  final validKeysMap = {
    'iss': '',
    'azp': '',
    'aud': '',
    'sub': '',
    'email': '',
    'email_verified': '',
    'name': '',
    'picture': '',
    'given_name': '',
    'family_name': '',
    'iat': '',
    'exp': '',
    'alg': '',
    'kid': '',
    'typ': '',
  };

  final responseKeys = response.keys;
  for (final key in responseKeys) {
    if (!validKeysMap.containsKey(key)) {
      return false;
    }
  }

  return true;
}
