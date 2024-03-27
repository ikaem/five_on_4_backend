import '../../../features/auth/data/entities/google_validated_id_token_response/google_validated_id_token_response_entity.dart';
import '../../../features/core/presentation/router/domain/values/http_request_value.dart';
import '../../libraries/dio/dio_wrapper.dart';

part 'constants.dart';

class GoogleIdTokenValidatorWrapper {
  const GoogleIdTokenValidatorWrapper({
    required DioWrapper dioWrapper,
  }) : _dioWrapper = dioWrapper;

  final DioWrapper _dioWrapper;

  Future<GoogleValidatedIdTokenResponseEntity?> validateIdToken({
    required String idToken,
  }) async {
    final response = await _dioWrapper.get<Map<String, dynamic>>(
      uriParts: HttpRequestUriPartsValue(
        // TODO extract this
        apiUrlScheme: "https",
        apiBaseUrl: 'www.googleapis.com',
        apiContextPath: 'oauth2/v3',
        apiEndpointPath: 'tokeninfo',
        queryParameters: {
          'id_token': idToken,
        },
      ),
    );

    final isInvalid = response.containsKey('error_description');
    if (isInvalid) {
      return null;
    }

    final entity =
        GoogleValidatedIdTokenResponseEntity.fromJson(json: response);

    return entity;
  }

  // String get url => HttpConstants

  // https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=XYZ123
  // https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${access_token}
}


// Expected this library to be part of 'file:///Users/karlo/development/mine/servers_dart_testing/drift_server/bin/src/wrappers/local/google_id_token_validator/google_id_token_validator_wrapper.dart', not 'file:///Users/karlo/development/mine/servers_dart_testing/drift_server/bin/src/wrappers/local/google_id_token_validator/constants.dart'.
