import '../../../../wrappers/local/google_apis/google_apis_wrapper.dart';
import '../../data/data_sources/auth_data_source.dart';
import '../values/new_auth_data_value.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required GoogleApisWrapper googleIdTokenValidatorWrapper,
    required AuthDataSource authDataSource,
  })  : _googleIdTokenValidatorWrapper = googleIdTokenValidatorWrapper,
        _authDataSource = authDataSource;

  final GoogleApisWrapper _googleIdTokenValidatorWrapper;
  final AuthDataSource _authDataSource;

  // what this does is
  // - it gets idtoken
  // if id token is good, we will proceed with login with google
  // if this user does not exist in db, we will create it
  // and we will return authModel or maybe player model

  // TODO this will
  @override
  Future<int?> googleLogin({
    required String idToken,
  }) async {
    final validatedGoogleAuthResponse =
        await _googleIdTokenValidatorWrapper.validateIdToken(
      idToken: idToken,
    );

    if (validatedGoogleAuthResponse == null) {
      return null;
    }

    final authEntityData = await _authDataSource.getAuthByEmail(
      email: validatedGoogleAuthResponse.email,
    );

    if (authEntityData != null) {
      return authEntityData.id;
    }

    // create new auth because this is google
    final newAuthEntityValue = NewAuthDataValueGoogle(
      email: validatedGoogleAuthResponse.email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      firstName: validatedGoogleAuthResponse.givenName,
      lastName: validatedGoogleAuthResponse.familyName,
      nickname: validatedGoogleAuthResponse.givenName,
    );

    final authId = await _authDataSource.createAuth(
      authValue: newAuthEntityValue,
    );

    return authId;
  }
}
