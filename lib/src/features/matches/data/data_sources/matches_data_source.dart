import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/matches/data/data_sources/matches_data_source_impl.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/match_entity_value.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../domain/values/create_match_value.dart';
import '../../domain/values/match_search_filter_value.dart';

abstract interface class MatchesDataSource {
  // TODO eventually return value from here
  Future<MatchEntityValue?> getMatch({
    required int matchId,
  });

  Future<int> createMatch({
    required CreateMatchValue createMatchValue,
  });

  /// returns a list of matches that the player is a participant in
  ///
  /// returned value is a list of matches that includes max 5 of each:
  /// - upcoming matches
  /// - today matches
  /// - past matches
  Future<List<MatchEntityData>> getPlayerMatchesOverview({
    required int playerId,
  });

  // TODO we should use our own custom value class here, so we dont depend on library solution
  Future<List<MatchEntityData>> searchMatches({
    // TODO in future
    required MatchSearchFilterValue filter,
  });
}

// TODO move to values
