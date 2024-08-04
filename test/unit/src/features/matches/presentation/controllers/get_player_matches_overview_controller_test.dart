// should have request validation body

// should have provided playaer id exist as a player

// should return expected response

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/matches/domain/models/match_model.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/get_player_matches_overview/get_player_matches_overview_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/get_player_matches_overview_controller.dart';
import 'package:five_on_4_backend/src/features/matches/utils/constants/get_player_matches_overview_request_body_key_constants.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final getPlayerMatchesOverviewUseCase =
      _MockGetPlayerMatchesOverviewUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();

  // tested class
  final controller = GetPlayerMatchesOverviewController(
    getPlayerMatchesOverviewUseCase: getPlayerMatchesOverviewUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
  );

  tearDown(() {
    reset(request);
    reset(getPlayerMatchesOverviewUseCase);
    reset(getPlayerByIdUseCase);
  });

  group("$GetPlayerMatchesOverviewController", () {
    group(".call()", () {
      final playerId = 1;
      final validatedBodyMap = {
        GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value:
            playerId
      };

      test(
        "given request validation has not been done"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.context).thenReturn({});

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
              responseMessage: "Request body not validated.");
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
        "given provided player id does not exist as a player"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });

          // given
          when(() => getPlayerByIdUseCase(id: playerId))
              .thenAnswer((_) async => null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          // TODO maybe bad request even
          final expectedResponse = generateTestNotFoundResponse(
              responseMessage:
                  "Unable to find player for the provided playerId.");
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

          final responseMatches = List.generate(
              3,
              (index) => MatchModel(
                    id: index + 1,
                    dateAndTime: DateTime.now().millisecondsSinceEpoch,
                    description: "description",
                    location: "location",
                    title: "title",
                  ));

          when(() => getPlayerByIdUseCase(id: playerId)).thenAnswer(
            (_) async => PlayerModel(
              id: playerId,
              // name: "name",
              firstName: "firstName",
              lastName: "lastName",
              authId: 1,
              nickname: "nickname",
            ),
          );
          when(() => getPlayerMatchesOverviewUseCase(playerId: playerId))
              .thenAnswer(
            (_) async => responseMatches,
          );

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseMessage: "Player matches overview retrieved successfully.",
            responseData: {
              "matches": responseMatches
                  .map((e) => {
                        "id": e.id,
                        "title": e.title,
                        "dateAndTime": e.dateAndTime,
                        "location": e.location,
                        "description": e.description,
                      })
                  .toList()
            },
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

class _MockRequest extends Mock implements Request {}

class _MockGetPlayerMatchesOverviewUseCase extends Mock
    implements GetPlayerMatchesOverviewUseCase {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}
