import '../models/match_model.dart';

abstract interface class MatchesRepository {
  Future<MatchModel?> getMatch({
    required int matchId,
  });
}
