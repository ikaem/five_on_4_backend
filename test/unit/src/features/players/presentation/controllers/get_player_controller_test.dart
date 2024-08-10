import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/get_player_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();

  // tested class
  final controller = GetPlayerController(
    getPlayerByIdUseCase: getPlayerByIdUseCase,
  );

  tearDown(() {
    reset(request);
    reset(getPlayerByIdUseCase);
  });

  group("$GetPlayerController", () {
    group(".call()", () {
      test(
        "given Url Parameters validation has not been done"
        "when [.call()] is called"
        "then should return expected response",
        () async {
          // setup

          // given
          // normally, validatedUrlParametersData is an object inside context
          when(() => request.context).thenReturn({});

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
              responseMessage: "Request url parameters not validated.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given Url Parameters validation has been done"
        "when [.call()] is called"
        "then should call [GetPlayerByIdUseCase] with expected parameters",
        () async {
          // setup
          final validatedUrlParametersData = {
            "id": 1,
          };
          final contextMap = {
            RequestConstants.VALIDATED_URL_PARAMETERS_DATA.value:
                validatedUrlParametersData,
          };

          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => null);

          // given
          when(() => request.context).thenReturn(contextMap);

          // when
          await controller(request);

          // then
          verify(() => getPlayerByIdUseCase(id: 1)).called(1);

          // cleanup
        },
      );

      test(
        "given [GetPlayerByIdUseCase] returns null"
        "when [.call()] is called"
        "then should return expected response",
        () async {
          // setup
          final validatedUrlParametersData = {
            "id": 1,
          };
          final contextMap = {
            RequestConstants.VALIDATED_URL_PARAMETERS_DATA.value:
                validatedUrlParametersData,
          };
          when(() => request.context).thenReturn(contextMap);

          // given
          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestNotFoundResponse(
            responseMessage: "Player not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given [GetPlayerByIdUseCase] returns player"
        "when [.call()] is called"
        "then should return expected response",
        () async {
          // setup
          final player = PlayerModel(
            id: 1,
            firstName: "firstName",
            lastName: "lastName",
            nickname: "nickname",
            authId: 1,
          );
          final validatedUrlParametersData = {
            "id": 1,
          };
          final contextMap = {
            RequestConstants.VALIDATED_URL_PARAMETERS_DATA.value:
                validatedUrlParametersData,
          };
          when(() => request.context).thenReturn(contextMap);

          // given
          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => player);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseMessage: "Player retrieved successfully.",
            responseData: {
              "player": {
                "id": player.id,
                "firstName": player.firstName,
                "lastName": player.lastName,
                "nickname": player.nickname,
                // TODO eventually, remove auth id - we dont need that possibly
                // TODO also, need to define what is entitsy, what is model - any then maybe there is a third one - what is sent to the client - or should the model be that?
                "authId": player.authId,
              },
            },
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}
