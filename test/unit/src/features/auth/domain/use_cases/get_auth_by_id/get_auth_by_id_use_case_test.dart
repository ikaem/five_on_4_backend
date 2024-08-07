import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:five_on_4_backend/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import 'package:five_on_4_backend/src/features/core/domain/models/auth/auth_model.dart';

void main() {
  final authRepository = _MockAuthRepository();

// tested class
  final getAuthByIdUseCase = GetAuthByIdUseCase(
    authRepository: authRepository,
  );

  tearDown(() {
    reset(authRepository);
  });

  group("$GetAuthByIdUseCase", () {
    group(".call()", () {
      test(
        "given invalid authId "
        "when call '.call()'"
        "then should return null",
        () async {
          // setup
          when(() => authRepository.getAuthById(id: any(named: "id")))
              .thenAnswer((i) async => null);

          // given
          final id = 1;

          // when
          final authModel = await getAuthByIdUseCase.call(id: id);

          // then
          expect(authModel, isNull);

          // cleanup
        },
      );

      test(
        "given valid authId "
        "when call '.call()'"
        "then should return authModel",
        () async {
          // setup
          when(() => authRepository.getAuthById(id: any(named: "id")))
              .thenAnswer((i) async => testAuthModel);

          // given
          final id = 1;

          // when
          final authModel = await getAuthByIdUseCase.call(id: id);

          // then
          expect(authModel, testAuthModel);

          // cleanup
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
