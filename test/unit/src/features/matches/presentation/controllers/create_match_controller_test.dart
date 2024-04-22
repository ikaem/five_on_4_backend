import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/features/matches/domain/use_cases/create_match/create_match_use_case.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/create_match_controller.dart';
import '../../../../../../../bin/src/features/matches/utils/constants/match_create_request_body_constants.dart';

void main() {
  final createMatchUseCase = _MockCreateMatchUseCase();
  final request = _MockRequest();

  // tested class
  final createMatchController = CreateMatchController(
    createMatchUseCase: createMatchUseCase,
  );

  tearDown(() {
    reset(createMatchUseCase);
    reset(request);
  });

  // TODO no validation testing - CreateMatchValidatorMiddleware will do that

  group("$CreateMatchController", () {
    final validRequest = {
      MatchCreateRequestBodyConstants.TITLE.value: "valid_title",
      MatchCreateRequestBodyConstants.DATE_AND_TIME.value:
          DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
      MatchCreateRequestBodyConstants.LOCATION.value: "valid_location",
      MatchCreateRequestBodyConstants.DESCRIPTION.value: "valid_description",
    };
    group(".call()", () {
      test(
        "given valid request "
        "when call() is called "
        "then should return expected response ",
        () async {
          // setup

          when(() => createMatchUseCase.call(
                title: any(named: "title"),
                dateAndTime: any(named: "dateAndTime"),
                location: any(named: "location"),
                description: any(named: "description"),
                createdAt: any(named: "createdAt"),
                updatedAt: any(named: "updatedAt"),
              )).thenAnswer((i) async => 1);

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(validRequest));

          // when
          final response = await createMatchController(request);

          // then
          final expectedResponse = _generateTestSuccessResponse(
            matchId: 1,
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given valid request "
        "when call() is called "
        "then should call CreaateMatchUseCase",
        () async {
          // setup
          final nowDate =
              DateTime.now().normalizedToSeconds.millisecondsSinceEpoch;

          when(() => createMatchUseCase.call(
                title: any(named: "title"),
                dateAndTime: any(named: "dateAndTime"),
                location: any(named: "location"),
                description: any(named: "description"),
                createdAt: any(named: "createdAt"),
                updatedAt: any(named: "updatedAt"),
              )).thenAnswer((i) async => 1);

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(validRequest));

          // when
          await createMatchController(request);

          // then
          verify(() => createMatchUseCase.call(
                title: validRequest["title"] as String,
                dateAndTime: validRequest["dateAndTime"] as int,
                location: validRequest["location"] as String,
                description: validRequest["description"] as String,
                createdAt: nowDate,
                updatedAt: nowDate,
              )).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockCreateMatchUseCase extends Mock implements CreateMatchUseCase {}

class _MockRequest extends Mock implements Request {}

Response _generateTestSuccessResponse({
  required int matchId,
}) {
  return Response.ok(
    jsonEncode(
      {
        "ok": true,
        "matchId": matchId,
        "message": "Match created successfully.",
      },
    ),
    headers: {
      "content-type": "application/json",
    },
  );
}
