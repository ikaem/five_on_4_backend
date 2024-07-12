import '../../../core/domain/models/auth/auth_model.dart';

abstract class AuthRepository {
  // what this does is
  // - it gets idtoken
  // if id token is good, we will proceed with login with google
  // if this user does not exist in db, we will create it
  // and we will return authModel or maybe player model

  // TODO this will
  Future<int?> googleLogin({
    required String idToken,
  });

  Future<int> register({
    required String email,
    required String hashedPassword,
    required String firstName,
    required String lastName,
    required String nickname,
  });

  Future<AuthModel?> getAuthById({
    required int id,
  });

  Future<AuthModel?> getAuthByEmail({
    required String email,
  });

  Future<AuthModel?> getAuthByEmailAndHashedPassword({
    required String email,
    required String hashedPassword,
  });
}
