import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/crypt/crypt_wrapper.dart';

void main() {
  final cryptWrapper = _MockCryptWrapper();

  // tested class
  final getHashedValueUseCase = GetHashedValueUseCase(
    cryptWrapper: cryptWrapper,
  );

  tearDown(() {
    reset(cryptWrapper);
  });

  group("$GetHashedValueUseCase", () {
    group(".call()", () {
      test(
        "given value"
        "when call() is called"
        "then should return expected hashed value",
        () async {
          // setup
          when(() => cryptWrapper.getHashedValue(value: any(named: "value")))
              .thenReturn("hashedValue");

          // given
          final value = "value";

          // when
          final hashedValue = getHashedValueUseCase(value: value);

          // then
          expect(hashedValue, equals("hashedValue"));

          // cleanup
        },
      );
    });
  });
}

class _MockCryptWrapper extends Mock implements CryptWrapper {}
