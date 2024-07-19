import 'package:drift/drift.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../../wrappers/local/database/database_wrapper.dart';
import '../../../core/utils/extensions/date_time_extension.dart';
import '../../domain/values/create_match_value.dart';
import '../../domain/values/match_search_filter_value.dart';
import 'matches_data_source.dart';

/* 

    final matches = await (findMatches..limit(5)).get();
    // ..limit(5)
    // ..get();

    return matches;






 */

class MatchesDataSourceImpl implements MatchesDataSource {
  MatchesDataSourceImpl({
    required DatabaseWrapper databaseWrapper,
  }) : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;

  @override
  Future<List<MatchEntityData>> searchMatches({
    required MatchSearchFilterValue filter,
  }) async {
    final matchTitle = filter.matchTitle;

    final select = _databaseWrapper.matchesRepo.select();

    // final levensteinDistance = CustomExpression<List<dynamic>>()
    // TODO I HOPE THIS sanitizes the input
    // TODO maybe there is some package that will saniztize it - check it
    // LEVENSHTEIN(title, ${variable.value})

    // final customExpression = CustomExpression<List<dynamic>>("""
    //   select
    //     *,
    //     LEVENSHTEIN(title, 'asd')
    //   from
    //     match_entity
    //   limit 5;
    //   """);

// TODO ---------------- i dont know how to work with this -------------------------

    // final isSimularTitleFunctionCallExrpession =
    //     FunctionCallExpression("LEVENSHTEIN", [
    //   Variable.withString("title"),
    //   Variable.withString("asd"),
    // ]);

    SimpleSelectStatement<$MatchEntityTable, MatchEntityData> findMatches =
        select;

    if (matchTitle != null) {
      final matchTitleVariable = Variable.withString(matchTitle);
      final isSimilarTitleExpression = CustomExpression<bool>(
        "LEVENSHTEIN(title, '${matchTitleVariable.value}') <= 3",
        precedence: Precedence.primary,
      );

      findMatches = findMatches
        ..where((tbl) {
          return isSimilarTitleExpression;
        });
    }

    final matches = await (findMatches..limit(5)).get();

    // final result = await customExpression.
// TODO ---------------- i dont know how to work with this -------------------------

/* 
        select 
          *
        from 
          match_entity
        where 
          LEVENSHTEIN(title, 'in') <= 2
        limit 5;

 */

    /* 
          """
      select
        *,
        LEVENSHTEIN(title, '?')
      from
        match_entity
      limit 5;
      """,
    
     */

// TODO leave here for now
    // TODO this works easy, but variable does not work
    // CustomSelectStatement<List<dynamic>>? findMatches;
    // LEVENSHTEIN(title, 'asd')
    // final customSelect = CustomSelectStatement(
    //   """
    //     select
    //       *
    //     from
    //       match_entity
    //     where
    //       LEVENSHTEIN(title, '?') <= 2
    //     limit 5;
    //   """,
    //   [
    // TODO it does not react to variables here
    //     // Variable("iv"),
    //     // Variable.withString("iv"),
    //     Variable.withInt(2)
    //   ],
    //   {
    //     // TODO not even needed it seems
    //     _databaseWrapper.db.matchEntity,
    //   },
    //   _databaseWrapper.db,
    // );
    // final result = await customSelect.get();
    // TODO there is .map on customSelect, so that should be used

    return matches;

    // TODO ---- this works
    // final findMatches = select
    //   ..where((tbl) {
    //     // TODO i would prefer something more fuzzy here
    //     final isMatchTitle = tbl.title.like('%${filter.matchTitle}%');
    //     // final isMatchTitleSimilar = FunctionCallExpression("", arguments)

    //     // final something = FunctionCallExpression(functionName, arguments);

    //     // final isSimilarToMatchTitle = tbl.title.

    //     return isMatchTitle;
    //   });

    // final matches = await (findMatches..limit(5)).get();
    // return matches;
  }

  @override
  Future<MatchEntityData?> getMatch({
    required int matchId,
  }) async {
    final select = _databaseWrapper.matchesRepo.select();
    final findMatch = select..where((tbl) => tbl.id.equals(matchId));

    final match = await findMatch.getSingleOrNull();
    return match;
  }

  @override
  Future<int> createMatch({
    required CreateMatchValue createMatchValue,
  }) async {
    final matchDateAndTime = DateTime.fromMillisecondsSinceEpoch(
      createMatchValue.dateAndTime,
    ).normalizedToSeconds;

    final createdAtTime = DateTime.fromMillisecondsSinceEpoch(
      createMatchValue.createdAt,
    ).normalizedToSeconds;
    final updatedAtTime = DateTime.fromMillisecondsSinceEpoch(
      createMatchValue.updatedAt,
    ).normalizedToSeconds;

    final companion = MatchEntityCompanion.insert(
      title: createMatchValue.title,
      dateAndTime: matchDateAndTime,
      location: createMatchValue.location,
      description: createMatchValue.description,
      createdAt: createdAtTime,
      updatedAt: updatedAtTime,
    );

    // TODO this should probably be a transaction
    final id = await _databaseWrapper.matchesRepo.insertOne(companion);

    return id;
  }

  @override
  Future<List<MatchEntityData>> getPlayerMatchesOverview({
    required int playerId,
  }) async {
    // today matches
    // TODO abstract this into a method

    final todayMatches = await _getPlayerMatchesOverviewToday(
      playerId: playerId,
    );
    final upcomingMatches = await _getPlayerMatchesOverviewUpcoming(
      playerId: playerId,
    );
    final pastMatches = await _getPlayerMatchesOverviewPast(
      playerId: playerId,
    );

    final allMatches = [
      ...todayMatches,
      ...upcomingMatches,
      ...pastMatches,
    ];

    return allMatches;
  }

  // TODO this could maybe be one function - _getPlayerMatchesOverviewSegment

  // TODO maybe temp
  // TODO hide this or abstract all of these getters functions somehow
  Future<List<MatchEntityData>> _getPlayerMatchesOverviewPast({
    required int playerId,
  }) async {
    final now = DateTime.now();
    final firstMomentOfToday = DateTime(
      now.year,
      now.month,
      now.day,
      0,
      0,
      0,
      0,
      0,
    );

    final select = _databaseWrapper.matchesRepo.select();
    final findMatches = select
      ..where((tbl) {
        // TODO will need to have miggration here to include participants on the match tale as well
        final isPastDate = tbl.dateAndTime.isSmallerThanValue(
          firstMomentOfToday,
        );

        return isPastDate;
      });

    // TODO dont forget ordering here as well
    final matches = await (findMatches..limit(5)).get();
    // ..limit(5)
    // ..get();

    return matches;
  }

  // TODO maybe temp
  Future<List<MatchEntityData>> _getPlayerMatchesOverviewUpcoming({
    required int playerId,
  }) async {
    final now = DateTime.now();
    final lastMomentOfToday = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
      999,
      999,
    );

    final select = _databaseWrapper.matchesRepo.select();
    final findMatches = select
      ..where((tbl) {
        // TODO will need to have miggration here to include participants on the match tale as well
        final isUpcomingDate = tbl.dateAndTime.isBiggerThanValue(
          lastMomentOfToday,
        );

        return isUpcomingDate;
      });

    // TODO dont forget ordering here as well
    final matches = await (findMatches..limit(5)).get();
    // ..limit(5)
    // ..get();

    return matches;
  }

  // TODO temp
  Future<List<MatchEntityData>> _getPlayerMatchesOverviewToday({
    required int playerId,
  }) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    // TODO create extension on datetime for this
    final lastMomentOfYesterday = DateTime(
      yesterday.year,
      yesterday.month,
      yesterday.day,
      23,
      59,
      59,
      999,
      999,
      // TODO this might need to be normalized to seconds or something - we will see
    );

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final firstMomentOfTomorrow = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      0,
      0,
      0,
      0,
      0,
    );

    // find all matches
    final select = _databaseWrapper.matchesRepo.select();
    final findMatches = select
      ..where((tbl) {
        // TODO come back to this - we will need migration here
        // TODO for now, this does not work yet
        // final isPlayerParticipant = tbl.participants.contains(playerId);
        final isDateToday = tbl.dateAndTime.isBetweenValues(
          lastMomentOfYesterday,
          firstMomentOfTomorrow,
        );

        return isDateToday;
      });

    // TODO dont forget ordering here as well
    final matches = await (findMatches..limit(5)).get();
    // ..limit(5)
    // ..get();

    return matches;
  }
}
