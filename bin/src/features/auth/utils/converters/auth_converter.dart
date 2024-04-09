// TODO test this
import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../core/presentation/router/domain/models/auth/auth_model.dart';

abstract class AuthConverter {
  // do not allow extending
  AuthConverter._();

  static AuthModel modelFromEntity({
    required AuthEntityData entity,
  }) {
    final model = AuthModel(
      id: entity.id,
      email: entity.email,
      createdAt: entity.createdAt.millisecondsSinceEpoch,
      updatedAt: entity.updatedAt.millisecondsSinceEpoch,
    );

    return model;
  }
}
