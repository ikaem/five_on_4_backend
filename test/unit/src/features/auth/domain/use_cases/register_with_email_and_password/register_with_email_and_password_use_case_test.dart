import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';

void main() {
  final authRepository = _MockAuthRepository();

  // tested class
  final registerWithEmailAndPassowordUseCase =
      RegisterWithEmailAndPasswordUseCase(
    authRepository: authRepository,
  );

  tearDown(() {
    reset(authRepository);
  });

  group("$RegisterWithEmailAndPasswordUseCase", () {
    group(".call()", () {
      test(
        "given valid arguments"
        "when .call() is called"
        "then should call AuthRepository.register and return authId",
        () async {
          // setup
          when(() => authRepository.register(
                email: any(named: "email"),
                hashedPassword: any(named: "password"),
                firstName: any(named: "firstName"),
                lastName: any(named: "lastName"),
                nickname: any(named: "nickname"),
              )).thenAnswer((i) async => 1);

          // given
          // TODO dont forget to validatze in validtor that strings are not empty
          final email = "valid_email";
          final password = "valid_password";
          final firstName = "valid_firstName";
          final lastName = "valid_lastName";
          final nickname = "valid_nickname";

          // when
          final authId = await registerWithEmailAndPassowordUseCase.call(
            email: email,
            hashedPassword: password,
            firstName: firstName,
            lastName: lastName,
            nickname: nickname,
          );

          // then
          verify(() => authRepository.register(
                email: email,
                hashedPassword: password,
                firstName: firstName,
                lastName: lastName,
                nickname: nickname,
              )).called(1);
          expect(authId, 1);

          // cleanup
        },
      );
    });
  });
}

class _MockAuthRepository extends Mock implements AuthRepository {}
