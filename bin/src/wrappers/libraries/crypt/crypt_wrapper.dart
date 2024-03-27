import 'package:crypt/crypt.dart';

class CryptWrapper {
  CryptWrapper({
    required this.passwordSalt,
  });

  final String passwordSalt;

  String getHashedPassword({required String password}) {
    final Crypt crypt = Crypt.sha256(password, salt: passwordSalt);
    final hash = crypt.hash;

    return hash;
  }

  bool checkIfPasswordsMatch({
    required String providedPassword,
    required String hashedPassword,
  }) {
    final Crypt crypt = Crypt.sha256(providedPassword, salt: passwordSalt);
    final providedPassHash = crypt.hash;

    final isMatch = providedPassHash == hashedPassword;
    return isMatch;

    // TODO lets try like this
    // final isMatch = crypt.match(hashedPassword);
    // final isMatch = crypt.match("hellopass");
    // return isMatch;
  }
}
