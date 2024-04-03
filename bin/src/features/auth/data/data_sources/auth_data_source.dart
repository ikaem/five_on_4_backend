import 'package:equatable/equatable.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../domain/values/new_auth_data_value.dart';

abstract class AuthDataSource {
  Future<AuthEntityData?> getAuthByEmail({
    required String email,
  });

  Future<AuthEntityData?> getAuthByEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthEntityData?> getAuthById({
    required int id,
  });

  Future<int> createAuth({
    required NewAuthDataValue authValue,
  });
}
