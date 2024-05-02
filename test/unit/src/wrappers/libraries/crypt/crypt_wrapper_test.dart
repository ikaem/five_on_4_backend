import 'package:crypt/crypt.dart';
import 'package:test/test.dart';

import '../../../../../../bin/src/wrappers/libraries/crypt/crypt_wrapper.dart';

void main() {
  const passwordSalt = "passwordSalt";

  // tested class
  final cryptWrapper = CryptWrapper(passwordSalt: passwordSalt);

  group("$CryptWrapper", () {
    final expectedHashedValue = "CvtVN8Kh48I18qaI1TvjrPhxSp5ciW.4RA/8Q9RidpB";

    group(".getHashedValue", () {
      test(
        "given a string value"
        "when call .getHashedValue()"
        "then should return expected value",
        () async {
          // setup

          // given
          final value = "value";

          // when
          final hashedValue = cryptWrapper.getHashedValue(value: value);

          // then
          expect(hashedValue, equals(expectedHashedValue));

          // cleanup
        },
      );
    });
    group(",verifyValue()", () {
      test(
        "given non-matching provided value"
        "when call .verifyValue()"
        "then should return false",
        () async {
          // setup

          // given
          final providedValue = "non-matching-value";

          // when
          final isMatch = cryptWrapper.verifyValue(
            value: providedValue,
            hashedValue: expectedHashedValue,
          );

          // then
          expect(isMatch, isFalse);

          // cleanup
        },
      );

      test(
        "given matching provided value"
        "when call .verifyValue()"
        "then should return true",
        () async {
          // setup

          // given
          final providedValue = "value";

          // when
          final isMatch = cryptWrapper.verifyValue(
            value: providedValue,
            hashedValue: expectedHashedValue,
          );

          // then
          expect(isMatch, isTrue);

          // cleanup
        },
      );
    });
  });
}
