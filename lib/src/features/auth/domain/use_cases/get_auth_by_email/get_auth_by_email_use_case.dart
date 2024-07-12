import '../../../../core/domain/models/auth/auth_model.dart';
import '../../repositories/auth_repository.dart';

class GetAuthByEmailUseCase {
  GetAuthByEmailUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<AuthModel?> call({
    required String email,
  }) async {
    final auth = await _authRepository.getAuthByEmail(email: email);

    return auth;
  }
}
