import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';

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

// TODO these should probablsy returne some BriefEntity, so we dont get participants here - there is no need for that - we can only load participants when we get full match single one, detailed
  @override
  Future<List<MatchEntityData>> searchMatches({
    required MatchSearchFilterValue filter,
  }) async {
    final matchTitle = filter.matchTitle;
    // TODO test case when there no valid search filters

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

    // TODO we should not search if there is not filters at all - just return empty stuff - we dont want to search all

    if (matchTitle != null) {
      // TODO I hope this will handle sanitization
      final matchTitleVariable = Variable.withString(matchTitle);
      // TODO this is a bit silly - currently, "asd" for match title will return one match, even if there are only matches with these titles in db
      /* 
ivanović
ivan
ivka
ivo
ivor
ovan
      
       */
      final isSimilarTitleExpression = CustomExpression<bool>(
        // TODO maybe levenhstein is not that good for this - maybe there is better
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
    // return null;

    // return null;

    final select = _databaseWrapper.matchesRepo.select();
    final joinedSelect = select.join([
      leftOuterJoin(
        _databaseWrapper.playerMatchParticipationsRepo,
        _databaseWrapper.playerMatchParticipationsRepo.matchId.equalsExp(
          _databaseWrapper.matchesRepo.id,
        ),
      ),
      leftOuterJoin(
        _databaseWrapper.playersRepo,
        _databaseWrapper.playersRepo.id.equalsExp(
          _databaseWrapper.playerMatchParticipationsRepo.playerId,
        ),
      ),
    ]);

    final findMatchSelect = joinedSelect
      ..where(_databaseWrapper.matchesRepo.id.equals(matchId));

    // final match = await findMatchSelect.getSingleOrNull();

    final result = await findMatchSelect.get();

    if (result.isEmpty) {
      return null;
    }

    final matchData = result.first.readTable(_databaseWrapper.matchesRepo);
    final participationsData = result.map(
      (row) {
        // TODO we cal assem entity value here, and insert nickname here
        final participationData =
            row.readTable(_databaseWrapper.playerMatchParticipationsRepo);

        final playerData = row.readTable(_databaseWrapper.playersRepo);

        final participationEntityValue = PlayerMatchParticipationEntityValue(
          id: participationData.id,
          createdAt: participationData.createdAt,
          updatedAt: participationData.updatedAt,
          status: participationData.status,
          playerId: participationData.playerId,
          matchId: participationData.matchId,
          playerNickname: playerData.nickname,
        );

        return participationEntityValue;
      },
    ).toList();

    final MatchEntityValue matchEntityValue = MatchEntityValue(
      id: matchData.id,
      title: matchData.title,
      dateAndTime: matchData.dateAndTime,
      location: matchData.location,
      description: matchData.description,
      createdAt: matchData.createdAt,
      updatedAt: matchData.updatedAt,
      participtions: participationsData,
    );

    // final participationEntityValues = participationsInfo.map(
    //   (participation) {
    //     return PlayerMatchParticipationEntityValue(
    //       id: participation.id,
    //       createdAt: participation.createdAt,
    //       updatedAt: participation.updatedAt,
    //       status: participation.status,
    //       playerId: participation.playerId,
    //       matchId: participation.matchId,
    //       // TODO we will come back to this
    //       playerNickname: null,
    //     );
    //   },
    // ).toList();

    // final match = await findMatchSelect.get();
    // final data = (await findMatchSelect.get()).map((row) {

    //   final match = row.readTable(_databaseWrapper.matchesRepo);
    //   final playerMatchParticipation = row.readTable(_databaseWrapper.playerMatchParticipationsRepo);

    // } );

    // final matchData = await findMatchSelect.map((row) {
    //   final match = row.readTable(_databaseWrapper.matchesRepo);
    //   final playerMatchParticipation = row.readTable(
    //     _databaseWrapper.playerMatchParticipationsRepo,
    //   );

    //   return match;
    // }).get();

    // TODO this is possible, sure

    /////////////////////
    return null;

// TODO this works, all good
    // final select = _databaseWrapper.matchesRepo.select();
    // final findMatch = select..where((tbl) => tbl.id.equals(matchId));

    // final match = await findMatch.getSingleOrNull();
    // return match;
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

// TODO test only
class MatchEntityValue extends Equatable {
  const MatchEntityValue({
    required this.id,
    required this.title,
    required this.dateAndTime,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.participtions,
  });

  final int id;
  final String title;
  final DateTime dateAndTime;
  final String location;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PlayerMatchParticipationEntityValue> participtions;

  @override
  List<Object?> get props => [
        id,
        title,
        dateAndTime,
        location,
        description,
        createdAt,
        updatedAt,
      ];
}

class PlayerMatchParticipationEntityValue extends Equatable {
  const PlayerMatchParticipationEntityValue({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.playerId,
    required this.matchId,
    this.playerNickname,
  });

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PlayerMatchParticipationStatus status;
  final int playerId;
  final int matchId;

  // TODO this is not in the table, but lets put it here - we will join when needed
  final String? playerNickname;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        status,
        playerId,
        matchId,
        playerNickname,
      ];
}
