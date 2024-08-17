import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/data_sources/player_match_participations_data_source.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';
import 'package:five_on_4_backend/src/wrappers/local/database/database_wrapper.dart';

class PlayerMatchParticipationsDataSourceImpl
    implements PlayerMatchParticipationsDataSource {
  const PlayerMatchParticipationsDataSourceImpl({
    required DatabaseWrapper databaseWrapper,
  }) : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;

  @override
  Future<int> storeParticipation(
      {required StorePlayerMatchParticipationValue value}) async {
    // TODO dont need transaction i think

    final companion = PlayerMatchParticipationEntityCompanion.insert(
      createdAt: DateTime.fromMillisecondsSinceEpoch(value.createdAt)
          .normalizedToSeconds,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(value.updatedAt)
          .normalizedToSeconds,
      playerId: value.playerId,
      matchId: value.matchId,
      status: value.status,
    );

    // TODO custom upsert with do update when stuff other than priry key is conflicted - in this case, we have conflictiong unieue constraint consititn of player id and match id
    final id = await _databaseWrapper.playerMatchParticipationsRepo.insertOne(
      companion,
      onConflict: DoUpdate.withExcluded((old, excluded) {
        return PlayerMatchParticipationEntityCompanion.custom(
          // NOTE - excluded is the new value that was attempted to be inserted
          status: excluded.status,
        );
      }, target: [
        _databaseWrapper.playerMatchParticipationsRepo.playerId,
        _databaseWrapper.playerMatchParticipationsRepo.matchId,
      ]),
    );

    return id;
  }

  // @override
  // Future<int> createParticipation({
  //   required CreatePlayerMatchParticipationValue value,
  // }) async {
  //   final createdAtTime = DateTime.fromMillisecondsSinceEpoch(value.createdAt)
  //       .normalizedToSeconds;
  //   final updatedTime = DateTime.fromMillisecondsSinceEpoch(value.updatedAt)
  //       .normalizedToSeconds;

  //   final companion = PlayerMatchParticipationEntityCompanion.insert(
  //     createdAt: createdAtTime,
  //     updatedAt: updatedTime,
  //     playerId: value.playerId,
  //     matchId: value.matchId,
  //     status: PlayerMatchParticipationStatus.unknown,
  //   );

  //   final id =
  //       _databaseWrapper.playerMatchParticipationsRepo.insertOne(companion);

  //   return id;
  // }
}

// TODO move to values later
