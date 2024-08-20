import 'package:five_on_4_backend/src/features/player_match_participations/data/data_sources/player_match_participations_data_source.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/repositories/player_match_participations_repository.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/repositories/player_match_participations_repository_impl.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  final playerMatchParticipationsDataSource =
      _MockPlayerMatchParticipationsDataSource();

  // tested class
  final playerMatchParticipationsRepositoryImpl =
      PlayerMatchParticipationsRepositoryImpl(
    playerMatchParticipationsDataSource: playerMatchParticipationsDataSource,
  );

  setUpAll(() {
    registerFallbackValue(
      _FakeStorePlayerMatchParticipationValue(),
    );
  });

  tearDown(() {
    reset(playerMatchParticipationsDataSource);
  });

  group(
    "$PlayerMatchParticipationsRepository",
    () {
      group(
        ".storeParticipation()",
        () {
// should return expected id

          test(
            "given [StorePlayerMatchParticipationValue] is provided"
            "when [.storeParticipation()] is called "
            "then should return expected id",
            () async {
              // setup
              when(() => playerMatchParticipationsDataSource.storeParticipation(
                    value: any(named: "value"),
                  )).thenAnswer((_) => Future.value(1));

              // given
              final value = StorePlayerMatchParticipationValue(
                  playerId: 1,
                  matchId: 1,
                  createdAt: 1,
                  updatedAt: 1,
                  status: PlayerMatchParticipationStatus.arriving);

              // when
              final result = await playerMatchParticipationsRepositoryImpl
                  .storeParticipation(value: value);

              // then
              expect(result, equals(1));

              // cleanup
            },
          );

// should call data source with expected arguments

          test(
            "given [StorePlayerMatchParticipationValue] is provided"
            "when [.storeParticipation()] is called "
            "then should call [PlayerMatchParticipationsDataSource.storeParticipation()] with expected arguments",
            () async {
              // setup
              when(() => playerMatchParticipationsDataSource.storeParticipation(
                    value: any(named: "value"),
                  )).thenAnswer((_) => Future.value(1));

              // given
              final value = StorePlayerMatchParticipationValue(
                  playerId: 1,
                  matchId: 1,
                  createdAt: 1,
                  updatedAt: 1,
                  status: PlayerMatchParticipationStatus.arriving);

              // when
              await playerMatchParticipationsRepositoryImpl.storeParticipation(
                  value: value);

              // then
              verify(
                  () => playerMatchParticipationsDataSource.storeParticipation(
                        value: value,
                      ));

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockPlayerMatchParticipationsDataSource extends Mock
    implements PlayerMatchParticipationsDataSource {}

class _FakeStorePlayerMatchParticipationValue extends Fake
    implements StorePlayerMatchParticipationValue {}
