import '../../../../wrappers/local/google_apis/google_apis_wrapper.dart';
import '../../../core/domain/models/auth/auth_model.dart';
import '../../data/data_sources/auth_data_source.dart';
import '../../utils/converters/auth_converter.dart';
import '../values/new_auth_data_value.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required GoogleApisWrapper googleApisWrapper,
    required AuthDataSource authDataSource,
  })  : _googleApisWrapper = googleApisWrapper,
        _authDataSource = authDataSource;

  final GoogleApisWrapper _googleApisWrapper;
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
        await _googleApisWrapper.validateIdToken(
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
      firstName: validatedGoogleAuthResponse.givenName,
      lastName: validatedGoogleAuthResponse.familyName,
      nickname: validatedGoogleAuthResponse.givenName,
    );

    final authId = await _authDataSource.createAuth(
      authValue: newAuthEntityValue,
    );

    return authId;
  }

// TODO this does not need to be nullable - for
  @override
  Future<int> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String nickname,
  }) async {
    final newAuthEntityValue = NewAuthDataValueEmailPassword(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
    );

    final authId = await _authDataSource.createAuth(
      authValue: newAuthEntityValue,
    );
    return authId;
  }

  @override
  Future<AuthModel?> getAuthById({
    required int id,
  }) async {
    final authEntityData = await _authDataSource.getAuthById(
      id: id,
    );
    if (authEntityData == null) {
      return null;
    }

    final authModel = AuthConverter.modelFromEntity(entity: authEntityData);
    return authModel;
  }

  @override
  Future<AuthModel?> getAuthByEmail({
    required String email,
  }) async {
    final authEntityData = await _authDataSource.getAuthByEmail(
      email: email,
    );

    if (authEntityData == null) {
      return null;
    }

    final authModel = AuthConverter.modelFromEntity(entity: authEntityData);
    return authModel;
  }
}
