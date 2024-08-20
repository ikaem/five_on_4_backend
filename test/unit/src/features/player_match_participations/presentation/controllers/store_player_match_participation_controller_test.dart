// validation not done

// by some chance, validation done with unknown status

// should call specific use case for each status and return expected response

import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/dont_join_match/dont_join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/invite_to_match/invite_to_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/join_match/join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/controllers/store_player_match_participation_controller.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/constants/store_player_match_participation_request_query_params_key_constants.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final joinMatchUseCase = _MockJoinMatchUseCase();
  final dontJoinMatchUseCase = _MockDontJoinMatchUseCase();
  final inviteToMatchUseCase = _MockInviteToMatchUseCase();

  // tested class
  final controller = StorePlayerMatchParticipationController(
    joinMatchUseCase: joinMatchUseCase,
    dontJoinMatchUseCase: dontJoinMatchUseCase,
    inviteToMatchUseCase: inviteToMatchUseCase,
  );

  tearDown(() {
    reset(request);
    reset(joinMatchUseCase);
    reset(dontJoinMatchUseCase);
    reset(inviteToMatchUseCase);
  });

  group(
    "$StorePlayerMatchParticipationController",
    () {
      group(
        ".call()",
        () {
          test(
            "given url query params validation has not been done"
            "when [.call()] is called"
            "then should return expected response",
            () async {
              // setup

              // given
              // normally, validatedUrlQueryParams is an object inside context
              when(() => request.context).thenReturn({});

              // when
              final response = await controller(request);
              final responseString = await response.readAsString();

              // then
              final expectedResponse = generateTestInternalServerErrorResponse(
                responseMessage: "Request url query params not validated.",
              );
              final expectedResponseString =
                  await expectedResponse.readAsString();

              expect(responseString, equals(expectedResponseString));
              expect(response.statusCode, equals(expectedResponse.statusCode));

              // cleanup
            },
          );

          test(
            "given url query params validation has been done with unknown status"
            "when [.call()] is called"
            "then should return expected response",
            () async {
              // setup
              final validatedUrlQueryParamsData = {
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .MATCH_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PLAYER_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PARTICIPATION_STATUS.value: "unknown",
              };

              // given
              when(() => request.context).thenReturn({
                RequestConstants.VALIDATED_URL_QUERY_PARAMS.value:
                    validatedUrlQueryParamsData,
              });

              // when
              final response = await controller(request);
              final responseString = await response.readAsString();

              // then
              final expectedResponse = generateTestInternalServerErrorResponse(
                responseMessage:
                    "Unable to store player match participation due to invalid participation status: unknown.",
              );
              final expectedResponseString =
                  await expectedResponse.readAsString();

              expect(responseString, equals(expectedResponseString));
              expect(response.statusCode, equals(expectedResponse.statusCode));

              // cleanup
            },
          );

          test(
            "given url query params validation has been done with arriving status"
            "when [.call()] is called"
            "then should return call [JoinMatchUseCase] with expected parameters and return expected response",
            () async {
              // setup
              final validatedUrlQueryParamsData = {
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .MATCH_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PLAYER_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PARTICIPATION_STATUS.value: "arriving",
              };

              when(() => joinMatchUseCase(
                    matchId: any(named: "matchId"),
                    playerId: any(named: "playerId"),
                  )).thenAnswer((_) async => 1);

              // given
              when(() => request.context).thenReturn({
                RequestConstants.VALIDATED_URL_QUERY_PARAMS.value:
                    validatedUrlQueryParamsData,
              });

              // when
              final response = await controller(request);
              final responseString = await response.readAsString();

              // then
              final expectedResponse = generateTestOkResponse(
                responseMessage:
                    "Player match participation stored successfully.",
                responseData: {
                  "id": 1,
                },
              );
              final expectedResponseString =
                  await expectedResponse.readAsString();

              verify(() => joinMatchUseCase(
                    matchId: 1,
                    playerId: 1,
                  )).called(1);
              expect(responseString, equals(expectedResponseString));
              expect(response.statusCode, equals(expectedResponse.statusCode));

              // cleanup
            },
          );

          test(
            "given url query params validation has been done with notArriving status"
            "when [.call()] is called"
            "then should return call [DontJoinMatchUseCase] with expected parameters and return expected response",
            () async {
              // setup
              final validatedUrlQueryParamsData = {
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .MATCH_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PLAYER_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PARTICIPATION_STATUS.value: "notArriving",
              };

              when(() => dontJoinMatchUseCase(
                    matchId: any(named: "matchId"),
                    playerId: any(named: "playerId"),
                  )).thenAnswer((_) async => 1);

              // given
              when(() => request.context).thenReturn({
                RequestConstants.VALIDATED_URL_QUERY_PARAMS.value:
                    validatedUrlQueryParamsData,
              });

              // when
              final response = await controller(request);
              final responseString = await response.readAsString();

              // then
              final expectedResponse = generateTestOkResponse(
                responseMessage:
                    "Player match participation stored successfully.",
                responseData: {
                  "id": 1,
                },
              );
              final expectedResponseString =
                  await expectedResponse.readAsString();

              verify(() => dontJoinMatchUseCase(
                    matchId: 1,
                    playerId: 1,
                  )).called(1);
              expect(responseString, equals(expectedResponseString));
              expect(response.statusCode, equals(expectedResponse.statusCode));

              // cleanup
            },
          );

          test(
            "given url query params validation has been done with pendingDecision status"
            "when [.call()] is called"
            "then should return call [InviteToMatchUseCase] with expected parameters and return expected response",
            () async {
              // setup
              final validatedUrlQueryParamsData = {
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .MATCH_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PLAYER_ID.value: 1,
                StorePlayerMatchParticipationRequestQueryParamsKeyConstants
                    .PARTICIPATION_STATUS.value: "pendingDecision",
              };

              when(() => inviteToMatchUseCase(
                    matchId: any(named: "matchId"),
                    playerId: any(named: "playerId"),
                  )).thenAnswer((_) async => 1);

              // given
              when(() => request.context).thenReturn({
                RequestConstants.VALIDATED_URL_QUERY_PARAMS.value:
                    validatedUrlQueryParamsData,
              });

              // when
              final response = await controller(request);
              final responseString = await response.readAsString();

              // then
              final expectedResponse = generateTestOkResponse(
                responseMessage:
                    "Player match participation stored successfully.",
                responseData: {
                  "id": 1,
                },
              );
              final expectedResponseString =
                  await expectedResponse.readAsString();

              verify(() => inviteToMatchUseCase(
                    matchId: 1,
                    playerId: 1,
                  )).called(1);
              expect(responseString, equals(expectedResponseString));
              expect(response.statusCode, equals(expectedResponse.statusCode));

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockRequest extends Mock implements Request {}

class _MockJoinMatchUseCase extends Mock implements JoinMatchUseCase {}

class _MockDontJoinMatchUseCase extends Mock implements DontJoinMatchUseCase {}

class _MockInviteToMatchUseCase extends Mock implements InviteToMatchUseCase {}
