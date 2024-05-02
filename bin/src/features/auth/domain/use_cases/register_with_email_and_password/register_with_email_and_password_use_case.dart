import '../../repositories/auth_repository.dart';

class RegisterWithEmailAndPasswordUseCase {
  RegisterWithEmailAndPasswordUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<int?> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String nickname,
  }) async {
    return await _authRepository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
    );
  }
}
