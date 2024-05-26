import 'package:drift/backends.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';

import '../env_vars/env_vars_wrapper.dart';

class PostgresDelegatedDatabaseWrapper {
  const PostgresDelegatedDatabaseWrapper({
    required EnvVarsDBWrapper envVarsDBWrapper,
  }) : _envVarsDBWrapper = envVarsDBWrapper;

  final EnvVarsDBWrapper _envVarsDBWrapper;

  DelegatedDatabase get delegatedDatabase {
    final PgDatabase pgDatabase = PgDatabase(
      endpoint: Endpoint(
        host: _envVarsDBWrapper.host,
        username: _envVarsDBWrapper.username,
        password: _envVarsDBWrapper.password,
        database: _envVarsDBWrapper.database,
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.require,
        // TODO research which is better
        // sslMode: SslMode.verifyFull,
        onOpen: (connection) async {
          print("Connected!");
        },
      ),
    );

    return pgDatabase;
  }
}
