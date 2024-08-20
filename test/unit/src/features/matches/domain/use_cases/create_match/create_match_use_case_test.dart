import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/matches/domain/repositories/matches_repository.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/create_match/create_match_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/create_match_value.dart';

// TODO maybe

void main() {
  final matchesRepository = _MockMatchesRepository();

  // tested class
  final createMatchUseCase = CreateMatchUseCase(
    matchesRepository: matchesRepository,
  );

  setUpAll(() {
    registerFallbackValue(_FakeCreateMatchValue());
  });

  tearDown(() {
    reset(matchesRepository);
  });

  group("$CreateMatchUseCase", () {
    group(".call()", () {
      final createMatchValue = CreateMatchValue(
        title: "title",
        dateAndTime: DateTime.now().millisecondsSinceEpoch,
        location: "location",
        description: "description",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      test(
        "given valid data"
        "when call() is called"
        "then should return create match Id",
        () async {
          // setup
          when(() => matchesRepository.createMatch(
                  createMatchValue: any(named: "createMatchValue")))
              .thenAnswer((i) async => 1);

          // given
          final title = createMatchValue.title;
          final dateAndTime = createMatchValue.dateAndTime;
          final location = createMatchValue.location;
          final description = createMatchValue.description;
          final createdAt = createMatchValue.createdAt;
          final updatedAt = createMatchValue.updatedAt;

          // when
          final result = await createMatchUseCase.call(
            title: title,
            dateAndTime: dateAndTime,
            location: location,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
          );

          // then
          expect(result, equals(1));

          // cleanup
        },
      );

      test(
        "given valid data"
        "when call() is called"
        "then should call MatchesRepository.createMatch()",
        () async {
          // setup
          when(() => matchesRepository.createMatch(
                  createMatchValue: any(named: "createMatchValue")))
              .thenAnswer((i) async => 1);

          // given
          final title = createMatchValue.title;
          final dateAndTime = createMatchValue.dateAndTime;
          final location = createMatchValue.location;
          final description = createMatchValue.description;
          final createdAt = createMatchValue.createdAt;
          final updatedAt = createMatchValue.updatedAt;

          // when
          await createMatchUseCase.call(
            title: title,
            dateAndTime: dateAndTime,
            location: location,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
          );

          // then
          verify(() => matchesRepository.createMatch(
                createMatchValue: createMatchValue,
              )).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockMatchesRepository extends Mock implements MatchesRepository {}

class _FakeCreateMatchValue extends Fake implements CreateMatchValue {}
