import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/repositories/player_match_participations_repository.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/dont_join_match/dont_join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/join_match/join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  final playerMatchRepository = _MockPlayerMatchParticipationsRepository();

  // tested class
  final useCase = DontJoinMatchUseCase(
    playerMatchParticipationsRepository: playerMatchRepository,
  );

  setUpAll(() {
    registerFallbackValue(
      _FakeStorePlayerMatchParticipationValue(),
    );
  });

  tearDown(() {
    reset(playerMatchRepository);
  });

  group(
    "$DontJoinMatchUseCase",
    () {
      group(
        ".call()",
        () {
          // return id

          test(
            "given [playerId] and [matchId] are provided"
            "when [.call()] is called "
            "then should return expected id",
            () async {
              // setup
              when(() => playerMatchRepository.storeParticipation(
                      value: any(named: "value")))
                  .thenAnswer((_) => Future.value(1));

              // given
              final playerId = 1;
              final matchId = 1;

              // when
              final result = await useCase(
                playerId: playerId,
                matchId: matchId,
              );

              // then
              expect(result, equals(1));

              // cleanup
            },
          );

          // call repo with expected values
          test(
            "given [playerId] and [matchId] are provided"
            "when [.call()] is called "
            "then should call [PlayerMatchParticipationRepository.storeParticipation] with expected arguments",
            () async {
              // setup
              when(() => playerMatchRepository.storeParticipation(
                      value: any(named: "value")))
                  .thenAnswer((_) => Future.value(1));

              // given
              final playerId = 1;
              final matchId = 1;

              // when
              await useCase(
                playerId: playerId,
                matchId: matchId,
              );

              // then
              final expectedValue = StorePlayerMatchParticipationValue(
                playerId: playerId,
                matchId: matchId,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                status: PlayerMatchParticipationStatus.notArriving,
              );

              final call = verify(
                () => playerMatchRepository.storeParticipation(
                  value: captureAny(named: "value"),
                ),
              );

              // TODO capturing, becasue incorrectly, we are passing createdAt and updatedAt at the use case level
              // this should be done at the data soruce, or even better probably, at the db level
              // TODO create ticket to fix this for the whole project (there is more places like this)
              final value =
                  call.captured.first as StorePlayerMatchParticipationValue;

              expect(value.playerId, equals(expectedValue.playerId));
              expect(value.matchId, equals(expectedValue.matchId));
              // TODO skipping createdAt and updatedAt because of the above reason - will be fixed in the future
              expect(value.status, equals(expectedValue.status));

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockPlayerMatchParticipationsRepository extends Mock
    implements PlayerMatchParticipationsRepository {}

class _FakeStorePlayerMatchParticipationValue extends Fake
    implements StorePlayerMatchParticipationValue {}
