import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:five_on_4_backend/src/features/auth/domain/use_cases/google_login/google_login_use_case.dart';

void main() {
  final authRepository = _MockAuthRepository();
  final googleLoginUseCase = GoogleLoginUseCase(
    authRepository: authRepository,
  );

  tearDown(() {
    reset(authRepository);
  });

  group("$GoogleLoginUseCase", () {
    group(".call()", () {
      test(
        "given invalid idToken "
        "when .call() is called "
        "then should call AuthRepository.googleLogin and return null",
        () async {
          // setup
          when(() => authRepository.googleLogin(idToken: any(named: "idToken")))
              .thenAnswer((i) async => null);

          // given
          final idToken = "idToken";

          // when
          final authId = await googleLoginUseCase.call(idToken: idToken);

          // then
          verify(() => authRepository.googleLogin(idToken: idToken)).called(1);
          expect(authId, isNull);

          // cleanup
        },
      );

      test(
        "given valid idToken "
        "when .call() is called "
        "then should call AuthRepository.googleLogin and return authId",
        () async {
          // setup
          when(() => authRepository.googleLogin(idToken: any(named: "idToken")))
              .thenAnswer((i) async => 1);

          // given
          final idToken = "idToken";

          // when
          final authId = await googleLoginUseCase.call(idToken: idToken);

          // then
          verify(() => authRepository.googleLogin(idToken: idToken)).called(1);
          expect(authId, 1);

          // cleanup
        },
      );
    });
  });
}

class _MockAuthRepository extends Mock implements AuthRepository {}
