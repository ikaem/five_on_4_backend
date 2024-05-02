import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';

void main() {
  final authRepository = _MockAuthRepository();

  // tested class
  final getAuthByEmailUseCase = GetAuthByEmailUseCase(
    authRepository: authRepository,
  );

  tearDown(() {
    reset(authRepository);
  });

  group("$GetAuthByEmailUseCase", () {
    group(".call()", () {
      test(
        "given email without auth in repository"
        "when call '.call()'"
        "then should return null",
        () async {
          // setup
          when(() => authRepository.getAuthByEmail(email: any(named: "email")))
              .thenAnswer((i) async => null);

          // given
          final email = "email";

          // when
          final authModel = await getAuthByEmailUseCase.call(email: email);

          // then
          verify(() => authRepository.getAuthByEmail(email: email)).called(1);
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
          when(() => authRepository.getAuthByEmail(email: any(named: "email")))
              .thenAnswer((i) async => testAuthModel);

          // given
          final email = "email";

          // when
          final authModel = await getAuthByEmailUseCase.call(email: email);

          // then
          verify(() => authRepository.getAuthByEmail(email: email)).called(1);
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
