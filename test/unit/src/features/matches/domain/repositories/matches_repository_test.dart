import 'package:five_on_4_backend/src/features/matches/domain/values/match_entity_value.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/matches/data/data_sources/matches_data_source.dart';
import 'package:five_on_4_backend/src/features/matches/domain/repositories/matches_repository.dart';
import 'package:five_on_4_backend/src/features/matches/domain/repositories/matches_repository_impl.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/create_match_value.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/match_search_filter_value.dart';
import 'package:five_on_4_backend/src/features/matches/utils/converters/matches_converters.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';

void main() {
  final matchesDataSource = _MockMatchesDataSource();

  // tested class
  final matchesRepositoryImpl = MatchesRepositoryImpl(
    matchesDataSource: matchesDataSource,
  );

  setUpAll(() {
    registerFallbackValue(_FakeCreateMatchValue());
    registerFallbackValue(_FakeMatchSearchFilterValue());
  });

  tearDown(() {
    reset(matchesDataSource);
  });

  group("$MatchesRepository", () {
    group(".searchMatches()", () {
      // should return expected matches
      test(
        "given matches data source returns searched matches"
        "when .searchMatches() is called "
        "then should return expected matches",
        () async {
          // setup
          final matchesEntitiesData = List.generate(3, (index) {
            return MatchEntityData(
              createdAt: DateTime.now().normalizedToSeconds,
              dateAndTime: DateTime.now().normalizedToSeconds,
              description: "description",
              id: index + 1,
              location: "location",
              title: "title",
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });

          // given
          when(() =>
                  matchesDataSource.searchMatches(filter: any(named: "filter")))
              .thenAnswer((_) => Future.value(matchesEntitiesData));

          // when
          final result = await matchesRepositoryImpl.searchMatches(
              filter: MatchSearchFilterValue(
            matchTitle: "title",
          ));

          // then
          final expectedMatchValues = matchesEntitiesData
              .map((match) => MatchesConverter.modelFromEntity(entity: match))
              .toList();

          expect(result, equals(expectedMatchValues));

          // cleanup
        },
      );
    });

    group(".getPlayerMatchesOverview", () {
      // should return a list of matches that the player is a participant in
      test(
        "given player is a participant in matches "
        "when .getPlayerMatchesOverview() is called with playerId "
        "then should return expected list of matches",
        () async {
          // setup
          final matches = List.generate(3, (index) {
            return MatchEntityData(
              createdAt: DateTime.now().normalizedToSeconds,
              dateAndTime: DateTime.now().normalizedToSeconds,
              description: "description",
              id: index + 1,
              location: "location",
              title: "title",
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });

          // given
          when(() => matchesDataSource.getPlayerMatchesOverview(
                playerId: any(named: "playerId"),
              )).thenAnswer((i) async => matches);

          // when
          final result = await matchesRepositoryImpl.getPlayerMatchesOverview(
            playerId: 1,
          );

          // then
          final expectedMatches = matches
              .map((match) => MatchesConverter.modelFromEntity(entity: match))
              .toList();

          expect(result, equals(expectedMatches));

          // cleanup
        },
      );
    });

    group(".createMatch()", () {
      test(
        "given CreateMatchValue "
        "when .createMatch() is called "
        "then should return created match id",
        () async {
          // setup
          when(() => matchesDataSource.createMatch(
                createMatchValue: any(named: "createMatchValue"),
              )).thenAnswer((i) async => 1);

          // given
          final createMatchValue = CreateMatchValue(
            title: "title",
            dateAndTime: DateTime.now().millisecondsSinceEpoch,
            location: "location",
            description: "description",
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          // when
          final result = await matchesRepositoryImpl.createMatch(
            createMatchValue: createMatchValue,
          );

          // then
          verify(() => matchesDataSource.createMatch(
                createMatchValue: createMatchValue,
              )).called(1);
          expect(result, equals(1));

          // cleanup
        },
      );
    });

    group(".getMatch()", () {
      test(
        "given match does not exist in data source "
        "when .getMatch() is called with matchId "
        "then should return null",
        () async {
          // setup
          final matchId = 1;

          // given
          // TODO test if this is enough without verifying the call
          when(() => matchesDataSource.getMatch(matchId: matchId))
              .thenAnswer((i) async => null);

          // when
          final result = await matchesRepositoryImpl.getMatch(matchId: matchId);

          // then
          expect(result, isNull);

          // cleanup
          print("cleanup");
        },
      );

      test(
        "given match exists in data source "
        "when .getMatch() is called with matchId "
        "then should return match",
        () async {
          // setup
          final matchId = 1;
          final testMatchEntityValue = MatchEntityValue(
            id: matchId,
            title: "title",
            dateAndTime: DateTime.now().normalizedToSeconds,
            location: "location",
            description: "description",
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
            participtions: [],
          );

          // given
          // when(() => matchesDataSource.getMatch(matchId: matchId))
          //     .thenAnswer((i) async => testMatchEntityData);
          when(() => matchesDataSource.getMatch(matchId: matchId))
              .thenAnswer((i) async => testMatchEntityValue);

          // when
          final result = await matchesRepositoryImpl.getMatch(matchId: matchId);

          // then
          // final expectedMatch =
          //     MatchesConverter.modelFromEntity(entity: testMatchEntityData);
          final expectedMatch = MatchesConverter.modelFromEntityValue(
            entity: testMatchEntityValue,
          );
          expect(result, expectedMatch);

          // cleanup
          print("cleanup");
        },
      );
    });
  });
}

class _MockMatchesDataSource extends Mock implements MatchesDataSource {}

class _FakeCreateMatchValue extends Fake implements CreateMatchValue {}

class _FakeMatchSearchFilterValue extends Fake
    implements MatchSearchFilterValue {}

final testMatchEntityData = MatchEntityData(
  id: 1,
  title: "title",
  dateAndTime: DateTime.now().normalizedToSeconds,
  location: "location",
  description: "description",
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
);
