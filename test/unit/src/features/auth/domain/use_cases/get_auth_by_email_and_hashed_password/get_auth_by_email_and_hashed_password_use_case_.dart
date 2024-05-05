import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';

void main() {
  final authRepository = _MockAuthRepository();

  // tested class
  final getAuthByEmailAndHashedPasswordUseCase =
      GetAuthByEmailAndHashedPasswordUseCase(
    authRepository: authRepository,
  );

  tearDown(() {
    reset(authRepository);
  });

  group("$GetAuthByEmailAndHashedPasswordUseCase", () {
    group(".call()", () {
      test(
        "given email without auth in repository"
        "when call '.call()'"
        "then should return null",
        () async {
          // setup
          when(() => authRepository.getAuthByEmailAndHashedPassword(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword")))
              .thenAnswer((i) async => null);

          // given
          final email = "email";
          final hashedPassword = "hashedPassword";

          // when
          final authModel = await getAuthByEmailAndHashedPasswordUseCase.call(
              email: email, hashedPassword: hashedPassword);

          // then
          verify(() => authRepository.getAuthByEmailAndHashedPassword(
              email: email, hashedPassword: hashedPassword)).called(1);
          expect(authModel, isNull);

          // cleanup
        },
      );

      test(
        "given email with auth in repository"
        "when call '.call()'"
        "then should return authModel",
        () async {
          // setup
          when(() => authRepository.getAuthByEmailAndHashedPassword(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword")))
              .thenAnswer((i) async => testAuthModel);

          // given
          final email = "email";
          final hashedPassword = "hashedPassword";

          // when
          final authModel = await getAuthByEmailAndHashedPasswordUseCase.call(
              email: email, hashedPassword: hashedPassword);

          // then
          verify(() => authRepository.getAuthByEmailAndHashedPassword(
              email: email, hashedPassword: hashedPassword)).called(1);
          expect(authModel, testAuthModel);
        },
      );
    });
  });
}

class _MockAuthRepository extends Mock implements AuthRepository {}

final testAuthModel = AuthModel(
  id: 1,
  email: "email",
  createdAt: DateTime.now().microsecondsSinceEpoch,
  updatedAt: DateTime.now().microsecondsSinceEpoch,
);
