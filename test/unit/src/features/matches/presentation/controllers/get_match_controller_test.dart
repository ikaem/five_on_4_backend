import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../bin/src/features/matches/domain/models/match_model.dart';
import '../../../../../../../bin/src/features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';

void main() {
  final getMatchUseCase = _MockGetMatchUseCase();

  final request = _MockRequest();

  // tested class
  final getMatchController = GetMatchController(
    getMatchUseCase: getMatchUseCase,
  );

  tearDown(() {
    reset(getMatchUseCase);
    reset(request);
  });

  group("$GetMatchController", () {
    group(".call()", () {
      final matchId = 1;

      test(
        "given invalid match id"
        "when .call() is called"
        "then should return expected response",
        () async {
          // given
          final invalidMatchId = "not_an_int_parsable_string";
          when(() => request.context).thenReturn({
            "shelf_router/params": {
              "id": invalidMatchId,
            }
          });

          // when
          final response =
              // await getMatchController.call(request, invalidMatchId);
              await getMatchController.call(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            // ok: false,
            responseMessage: "Invalid match id provided.",
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
        "given match with provided id does not exist"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.context).thenReturn({
            "shelf_router/params": {
              "id": matchId.toString(),
            }
          });

          // given
          when(() => getMatchUseCase(matchId: any(named: "matchId")))
              .thenAnswer((_) async => null);

          // when
          final response =
              // await getMatchController.call(request, matchId.toString());
              await getMatchController.call(request);

          // then
          final expectedResponse = _generateTestNonExistentResponse(
            // ok: false,
            responseMessage: "Match not found.",
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
        "given match with provided id does exist"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.context).thenReturn({
            "shelf_router/params": {
              "id": matchId.toString(),
            }
          });

          // given
          when(() => getMatchUseCase(matchId: any(named: "matchId")))
              .thenAnswer((_) async => _testMatchModel);

          // when
          final response =
              // await getMatchController.call(request, matchId.toString());
              await getMatchController.call(
            request,
          );

          // then
          final expectedResponse = Response.ok(
            jsonEncode({
              "ok": true,
              "data": {
                // TODO crete to map converters or something like that - to response data maybe?
                "id": _testAuthModel.id,
                "title": _testMatchModel.title,
                "dateAndTime": _testMatchModel.dateAndTime,
                "location": _testMatchModel.location,
                "description": _testMatchModel.description,
              },
              "message": "Match found.",
            }),
            headers: {
              "Content-Type": "application/json",
            },
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
    });
  });
}

class _MockGetMatchUseCase extends Mock implements GetMatchUseCase {}

class _MockRequest extends Mock implements Request {}

Response _generateTestBadRequestResponse({
  // required bool ok,
  required String responseMessage,
}) {
  return Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": "Invalid request - $responseMessage.",
      },
    ),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

Response _generateTestNonExistentResponse({
  required String responseMessage,
}) {
  return Response.notFound(
    jsonEncode(
      {
        "ok": false,
        "message": "Resource not found - $responseMessage.",
      },
    ),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

final _testAuthModel = AuthModel(
  id: 1,
  email: "email",
  createdAt: DateTime.now().millisecondsSinceEpoch,
  updatedAt: DateTime.now().millisecondsSinceEpoch,
);

final _testMatchModel = MatchModel(
  id: 1,
  title: "title",
  dateAndTime: DateTime.now().millisecondsSinceEpoch,
  location: "location",
  description: "description",
);
