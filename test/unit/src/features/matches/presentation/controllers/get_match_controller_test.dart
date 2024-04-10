import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../bin/src/features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';

void main() {
  final getMatchUseCase = _MockGetMatchUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();

  final request = _MockRequest();

  // tested class
  final getMatchController = GetMatchController(
    getMatchUseCase: getMatchUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
  );

  setUp(() {
    reset(getMatchUseCase);
    reset(getPlayerByIdUseCase);
    reset(getAuthByIdUseCase);
    reset(request);
  });

  group("$GetMatchController", () {
    group(".call()", () {
      test(
        "given a request without accessToken cookie "
        "when .call() is called "
        "then should return expected response",
        () async {
          // lets see how request looks like even
          // setup

          // given

          // when

          // then

          // cleanup
        },
      );
    });
  });
}

class _MockGetMatchUseCase extends Mock implements GetMatchUseCase {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}

class _MockGetAuthByIdUseCase extends Mock implements GetAuthByIdUseCase {}

class _MockRequest extends Mock implements Request {}
