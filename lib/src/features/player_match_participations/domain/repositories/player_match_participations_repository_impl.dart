import 'package:five_on_4_backend/src/features/player_match_participations/data/data_sources/player_match_participations_data_source.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/repositories/player_match_participations_repository.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';

class PlayerMatchParticipationsRepositoryImpl
    implements PlayerMatchParticipationsRepository {
  const PlayerMatchParticipationsRepositoryImpl({
    required PlayerMatchParticipationsDataSource
        playerMatchParticipationsDataSource,
  }) : _playerMatchParticipationsDataSource =
            playerMatchParticipationsDataSource;

  final PlayerMatchParticipationsDataSource
      _playerMatchParticipationsDataSource;

  @override
  Future<int> storeParticipation({
    required StorePlayerMatchParticipationValue value,
  }) async {
    final id = await _playerMatchParticipationsDataSource.storeParticipation(
      value: value,
    );

    return id;
  }
}
