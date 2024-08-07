import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/create_match/create_match_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/create_match_controller.dart';
import 'package:five_on_4_backend/src/features/matches/utils/constants/match_create_request_body_key_constants.dart';
import '../../../../../../helpers/response.dart';

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
      MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
      MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value:
          DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
      MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
      MatchCreateRequestBodyKeyConstants.DESCRIPTION.value: "valid_description",
    };

    // TODO these fail
    group(".call()", () {
      test(
        "given request without validated body data "
        "when call() is called "
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.context).thenReturn({});

          // when
          final response = await createMatchController(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
              responseMessage: "Request body not validated.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given valid request"
        "when call() is called"
        "then should return expected response",
        () async {
          // setup
          final validatedBodyMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value:
                DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
          };

          when(() => createMatchUseCase.call(
                title: any(named: "title"),
                dateAndTime: any(named: "dateAndTime"),
                location: any(named: "location"),
                description: any(named: "description"),
                createdAt: any(named: "createdAt"),
                updatedAt: any(named: "updatedAt"),
              )).thenAnswer((i) async => 1);

          // given
          when(() => request.context).thenReturn({
            "validatedBodyData": validatedBodyMap,
          });

          // when
          final response = await createMatchController(request);
          final responseString = await response.readAsString();

          // then
          // final expectedResponse = _generateTestSuccessResponse(
          //   matchId: 1,
          // );
          final expectedResponse = generateTestOkResponse(
            responseData: {
              "matchId": 1,
            },
            responseMessage: "Match created successfully.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // test(
      //   "given valid request "
      //   "when call() is called "
      //   "then should return expected response ",
      //   () async {
      //     // setup

      //     when(() => createMatchUseCase.call(
      //           title: any(named: "title"),
      //           dateAndTime: any(named: "dateAndTime"),
      //           location: any(named: "location"),
      //           description: any(named: "description"),
      //           createdAt: any(named: "createdAt"),
      //           updatedAt: any(named: "updatedAt"),
      //         )).thenAnswer((i) async => 1);

      //     // given
      //     // when(() => request.readAsString())
      //     //     .thenAnswer((i) async => jsonEncode(validRequest));

      //     // when
      //     final response = await createMatchController(request);

      //     // then
      //     final expectedResponse = _generateTestSuccessResponse(
      //       matchId: 1,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));

      //     // cleanup
      //   },
      // );

      // test(
      //   "given valid request "
      //   "when call() is called "
      //   "then should call CreaateMatchUseCase",
      //   () async {
      //     // setup
      //     final nowDate =
      //         DateTime.now().normalizedToSeconds.millisecondsSinceEpoch;

      //     when(() => createMatchUseCase.call(
      //           title: any(named: "title"),
      //           dateAndTime: any(named: "dateAndTime"),
      //           location: any(named: "location"),
      //           description: any(named: "description"),
      //           createdAt: any(named: "createdAt"),
      //           updatedAt: any(named: "updatedAt"),
      //         )).thenAnswer((i) async => 1);

      //     // given
      //     when(() => request.readAsString())
      //         .thenAnswer((i) async => jsonEncode(validRequest));

      //     // when
      //     await createMatchController(request);

      //     // then
      //     verify(() => createMatchUseCase.call(
      //           title: validRequest["title"] as String,
      //           dateAndTime: validRequest["dateAndTime"] as int,
      //           location: validRequest["location"] as String,
      //           description: validRequest["description"] as String,
      //           createdAt: nowDate,
      //           updatedAt: nowDate,
      //         )).called(1);

      //     // cleanup
      //   },
      // );
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
