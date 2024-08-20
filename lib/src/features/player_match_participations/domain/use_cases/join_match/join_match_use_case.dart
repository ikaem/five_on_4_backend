import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/repositories/player_match_participations_repository.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';

class JoinMatchUseCase {
  const JoinMatchUseCase({
    required PlayerMatchParticipationsRepository
        playerMatchParticipationsRepository,
  }) : _playerMatchParticipationsRepository =
            playerMatchParticipationsRepository;

  final PlayerMatchParticipationsRepository
      _playerMatchParticipationsRepository;

  Future<int> call({
    required int playerId,
    required int matchId,
  }) async {
    final storeValue = StorePlayerMatchParticipationValue(
      playerId: playerId,
      matchId: matchId,
      // TODO this is not good - these created arguments should not be set here - they should be set at the data source or db level
      // because if we set them here, we might, in theory, always set created at anew, which is not good
      // TODO create ticket to fix this
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      status: PlayerMatchParticipationStatus.arriving,
    );

    final id = await _playerMatchParticipationsRepository.storeParticipation(
      value: storeValue,
    );

    return id;
  }
}
