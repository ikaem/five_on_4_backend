import '../../../../core/presentation/router/domain/models/auth/auth_model.dart';
import '../../repositories/auth_repository.dart';

class GetAuthByIdUseCase {
  GetAuthByIdUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<AuthModel?> call({
    required int id,
  }) {
    return _authRepository.getAuthById(id: id);
  }
}
