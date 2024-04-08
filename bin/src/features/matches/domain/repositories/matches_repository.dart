abstract interface class MatchesDataSource {
  Future<MatchModel?> getMatch({
    required int matchId,
  });
}
