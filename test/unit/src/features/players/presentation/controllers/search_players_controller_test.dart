import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/search_players/search_players_use_case.dart';
import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/search_players_controller.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/search_players_request_body_key_constants.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final searchPlayersUseCase = _MockSearchPlayersUseCase();

// tested class
  final controller = SearchPlayersController(
    searchPlayersUseCase: searchPlayersUseCase,
  );

  setUpAll(() {
    registerFallbackValue(_FakePlayersSearchFilterValue());
  });

  tearDown(() {
    reset(request);
    reset(searchPlayersUseCase);
  });

  group(
    "$SearchPlayersController",
    () {
      test(
        "given request validation has not been done"
        "when [.call()] is called"
        "then should return expected response",
        () async {
          // setup

          // given
          // normally, validatedUrlParams is an object inside context
          when(() => request.context).thenReturn({});

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
              responseMessage: "Request url query params not validated.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given request validation has been done"
        "when [.call()] is called"
        "then should call [SearchPlayersUseCase] with correct arguments",
        () async {
          // setup
          final validatedUrlQueryParamsDataMap = {
            SearchPlayersRequestBodyKeyConstants.NAME_TERM.value: "name",
          };

          when(() => searchPlayersUseCase(
                filter: any(named: "filter"),
              )).thenAnswer((_) async => []);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_URL_QUERY_PARAMS.value:
                validatedUrlQueryParamsDataMap,
          });

          // when
          await controller(request);

          // then
          final expectedFilter = PlayersSearchFilterValue(
            nameTerm: "name",
          );

          verify(() => searchPlayersUseCase(filter: expectedFilter)).called(1);

          // cleanup
        },
      );

      test(
        "given [SearchPlayersUseCase] returns list of players"
        "when [.call()] is called"
        "then should return expected response",
        () async {
          // setup
          final validatedUrlQueryParamsDataMap = {
            SearchPlayersRequestBodyKeyConstants.NAME_TERM.value: "name",
          };

          final responsePlayers = List.generate(
              3,
              (index) => PlayerModel(
                    id: index + 1,
                    name: "name",
                    authId: index + 1,
                    nickname: "nickname",
                  ));

          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_URL_QUERY_PARAMS.value:
                validatedUrlQueryParamsDataMap,
          });

          // given
          when(() => searchPlayersUseCase(
                filter: any(named: "filter"),
              )).thenAnswer((_) async => responsePlayers);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseMessage: "Players searched successfully.",
            responseData: {
              "players": responsePlayers
                  .map((e) => {
                        "id": e.id,
                        "name": e.name,
                        "authId": e.authId,
                        "nickname": e.nickname,
                      })
                  .toList(),
            },
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );
    },
  );
}

class _MockSearchPlayersUseCase extends Mock implements SearchPlayersUseCase {}

class _MockRequest extends Mock implements Request {}

class _FakePlayersSearchFilterValue extends Fake
    implements PlayersSearchFilterValue {}
