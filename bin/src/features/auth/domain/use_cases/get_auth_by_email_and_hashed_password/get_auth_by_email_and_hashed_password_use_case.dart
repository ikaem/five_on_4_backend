import '../../../../core/domain/models/auth/auth_model.dart';
import '../../repositories/auth_repository.dart';

class GetAuthByEmailAndHashedPasswordUseCase {
  GetAuthByEmailAndHashedPasswordUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<AuthModel?> call({
    required String email,
    required String hashedPassword,
  }) async {
    final auth = await _authRepository.getAuthByEmailAndHashedPassword(
      email: email,
      hashedPassword: hashedPassword,
    );

    return auth;
  }
}
