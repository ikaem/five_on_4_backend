import 'package:envied/envied.dart';

part 'env_vars_wrapper.g.dart';

@Envied(path: ".env")
class EnvVarsWrapper {
  @EnviedField(varName: "PGHOST")
  final String _pgHost = _EnvVarsWrapper._pgHost;

  @EnviedField(varName: "PGDATABASE")
  final String _pgDatabase = _EnvVarsWrapper._pgDatabase;

  @EnviedField(varName: "PGUSER")
  final String _pgUsername = _EnvVarsWrapper._pgUsername;

  @EnviedField(varName: "PGPASSWORD")
  final String _pgPassword = _EnvVarsWrapper._pgPassword;

  @EnviedField(varName: "AUTH_PASSWORD_SALT")
  final String _authPasswordSalt = _EnvVarsWrapper._authPasswordSalt;

  @EnviedField(varName: "JWT_SECRET")
  final String _jwtSecret = _EnvVarsWrapper._jwtSecret;

  EnvVarsDBWrapper get dbWrapper {
    return EnvVarsDBWrapper(
      host: _pgHost,
      database: _pgDatabase,
      username: _pgUsername,
      password: _pgPassword,
    );
  }

  EnvVarsAuthWrapper get authWrapper {
    return EnvVarsAuthWrapper(
      passwordSalt: _authPasswordSalt,
      jwtSecret: _jwtSecret,
    );
  }
}

class EnvVarsDBWrapper {
  EnvVarsDBWrapper({
    required this.host,
    required this.database,
    required this.username,
    required this.password,
  });
  final String host;
  final String database;
  final String username;
  final String password;
}

class EnvVarsAuthWrapper {
  EnvVarsAuthWrapper({
    required this.passwordSalt,
    required this.jwtSecret,
  });
  final String passwordSalt;
  final String jwtSecret;
}
