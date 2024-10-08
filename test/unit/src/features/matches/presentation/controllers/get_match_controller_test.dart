import 'dart:convert';

import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/models/player_match_participation_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/domain/models/auth/auth_model.dart';
import 'package:five_on_4_backend/src/features/matches/domain/models/match_model.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../helpers/response.dart';

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

// TODO this should be delegated to middleware
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
          final response = await getMatchController.call(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "Invalid match id provided.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
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
          final response = await getMatchController.call(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse =
              generateTestNotFoundResponse(responseMessage: "Match not found");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given valid request"
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
          final response = await getMatchController.call(
            request,
          );
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseData: {
              "match": {
                "id": _testAuthModel.id,
                "title": _testMatchModel.title,
                "dateAndTime": _testMatchModel.dateAndTime,
                "location": _testMatchModel.location,
                "description": _testMatchModel.description,
              },
              "participations":
                  _testMatchModel.participations.map((participation) {
                return {
                  "id": participation.id,
                  "status": participation.status,
                  "playerId": participation.playerId,
                  "matchId": participation.matchId,
                  "playerNickname": participation.playerNickname,
                };
              }).toList(),
            },
            responseMessage: "Match found",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
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
  participations: List.generate(3, (index) {
    return PlayerMatchParticipationModel(
      id: index + 1,
      status: PlayerMatchParticipationStatus.values[index].name,
      playerId: index + 1,
      matchId: 1,
      playerNickname: "playerNickname",
    );
  }),
);
