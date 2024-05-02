import 'package:crypt/crypt.dart';

class CryptWrapper {
  CryptWrapper({
    required this.passwordSalt,
  });

  final String passwordSalt;

  String getHashedValue({required String value}) {
    final Crypt crypt = Crypt.sha256(value, salt: passwordSalt);
    final hash = crypt.hash;

    return hash;
  }

  bool verifyValue({
    required String value,
    required String hashedValue,
  }) {
    final Crypt crypt = Crypt.sha256(value, salt: passwordSalt);
    final providedValueHash = crypt.hash;

    final isMatch = providedValueHash == hashedValue;
    return isMatch;

    // TODO lets try like this
    // final isMatch = crypt.match(hashedPassword);
    // final isMatch = crypt.match("hellopass");
    // return isMatch;
  }
}
