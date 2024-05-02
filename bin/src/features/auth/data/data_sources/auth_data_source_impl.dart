import 'package:drift/drift.dart';

import '../../../../wrappers/libraries/crypt/crypt_wrapper.dart';
import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../../wrappers/local/database/database_wrapper.dart';
import '../../../core/utils/extensions/date_time_extension.dart';
import '../../domain/values/new_auth_data_value.dart';
import 'auth_data_source.dart';

// TODO test this with sqlite db wrapped in dbwrapper
// TODO test all of this
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({
    required DatabaseWrapper databaseWrapper,
    required CryptWrapper cryptWrapper,
  })  : _databaseWrapper = databaseWrapper,
        _cryptWrapper = cryptWrapper;

  final DatabaseWrapper _databaseWrapper;
  final CryptWrapper _cryptWrapper;

  @override
  Future<int> createAuth({
    required NewAuthDataValue authValue,
  }) async {
    final authId = await _databaseWrapper.transaction(
      () async {
        // TODO extract this to a helper here
        final password = authValue.password;
        final hashedPassword = password == null
            ? null
            : _cryptWrapper.getHashedValue(value: password);

        final createdAt = DateTime.now().normalizedToSeconds;
        final updatedAt = createdAt;

        final authCompanion = AuthEntityCompanion.insert(
          email: authValue.email,
          password: Value(hashedPassword),
          authType: authValue.authType.name,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
        final authId = await _databaseWrapper.authRepo.insertOne(authCompanion);

        final playerCompanion = PlayerEntityCompanion.insert(
          firstName: authValue.firstName,
          lastName: authValue.lastName,
          nickname: authValue.nickname,
          authId: authId,
          createdAt: createdAt,
          updatedAt: updatedAt,
          teamId: Value(null),
        );
        await _databaseWrapper.playersRepo.insertOne(playerCompanion);

        return authId;
      },
    );

    return authId;
  }

  @override
  Future<AuthEntityData?> getAuthByEmail({required String email}) async {
    final select = _databaseWrapper.authRepo.select();
    final findAuth = select..where((tbl) => tbl.email.equals(email));

    final auth = await findAuth.getSingleOrNull();

    return auth;
  }

  @override
  Future<AuthEntityData?> getAuthByEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final hashedPassword = _cryptWrapper.getHashedValue(value: password);
    // TODO password will be hashed
    final select = _databaseWrapper.authRepo.select();
    final findAuth = select
      ..where((tbl) => tbl.email.equals(email))
      ..where((tbl) => tbl.password.equals(hashedPassword));

    final auth = await findAuth.getSingleOrNull();

    return auth;
  }

  @override
  Future<AuthEntityData?> getAuthById({required int id}) async {
    final select = _databaseWrapper.authRepo.select();
    final findAuth = select..where((tbl) => tbl.id.equals(id));

    final auth = await findAuth.getSingleOrNull();
    return auth;
  }
}
