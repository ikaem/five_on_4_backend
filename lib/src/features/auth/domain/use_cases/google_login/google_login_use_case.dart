// TODO make interface for all use cases
import '../../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  GoogleLoginUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<int?> call({
    required String idToken,
  }) async {
    return await _authRepository.googleLogin(idToken: idToken);
  }
}
