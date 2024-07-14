import 'package:five_on_4_backend/src/features/matches/domain/models/match_model.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/search_matches/search_matches_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/match_search_filter_value.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
import 'package:five_on_4_backend/src/features/matches/utils/constants/search_matches_request_body_key_constants.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final searchMatchesUseCase = _MockSearchMatchesUseCase();

  // tested class
  final controller = SearchMatchesController(
    searchMatchesUseCase: searchMatchesUseCase,
  );

  setUpAll(() {
    registerFallbackValue(_FakeMatchSearchFilterValue());
  });

  tearDown(() {
    reset(request);
    reset(searchMatchesUseCase);
  });

  group("$SearchMatchesController", () {
    // given request validation has not been done, return expected response
    test(
      "given request validation has not been done"
      "when .call() is called"
      "then should return expected response",
      () async {
        // setup

        // given
        // validatedBodyData is an object inside context normally
        when(() => request.context).thenReturn({});

        // when
        final response = await controller(request);
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

    // should return expected response
    test(
      "given request with validated body data"
      "when .call() is called"
      "then should return expected response",
      () async {
        // setup
        final validatedBodyDataMap = {
          SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value: "title",
        };
        final responseMatches = List.generate(
            3,
            (index) => MatchModel(
                  id: index + 1,
                  dateAndTime: DateTime.now().millisecondsSinceEpoch,
                  description: "description",
                  location: "location",
                  title: "title",
                ));

        when(() => searchMatchesUseCase(filter: any(named: "filter")))
            .thenAnswer((i) async => responseMatches);

        // given
        when(() => request.context).thenReturn({
          "validatedBodyData": validatedBodyDataMap,
        });

        // when
        final response = await controller(request);
        final responseString = await response.readAsString();

        // then
        final expectedResponse = generateTestOkResponse(
          responseMessage: "Matches searched successfully.",
          responseData: {
            "matches": responseMatches
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "dateAndTime": e.dateAndTime,
                      "location": e.location,
                      "description": e.description,
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

    // should call use case with expected arguments
    test(
      "given request with validated body data"
      "when .call() is called"
      "then should call SearchMatchesUseCase with expected arguments",
      () async {
        // setup
        final validatedBodyDataMap = {
          SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value: "title",
        };
        final responseMatches = List.generate(
            3,
            (index) => MatchModel(
                  id: index + 1,
                  dateAndTime: DateTime.now().millisecondsSinceEpoch,
                  description: "description",
                  location: "location",
                  title: "title",
                ));

        when(() => searchMatchesUseCase(filter: any(named: "filter")))
            .thenAnswer((i) async => responseMatches);

        // given
        when(() => request.context).thenReturn({
          "validatedBodyData": validatedBodyDataMap,
        });

        // when
        final response = await controller(request);
        // final responseString = await response.readAsString();

        // then
        final MatchSearchFilterValue expectedFilter = MatchSearchFilterValue(
          matchTitle: "title",
        );

        verify(() => searchMatchesUseCase(filter: expectedFilter)).called(1);
        // final expectedResponse = generateTestOkResponse(
        //   responseMessage: "Matches searched successfully.",
        //   responseData: {
        //     "matches": responseMatches
        //         .map((e) => {
        //               "id": e.id,
        //               "title": e.title,
        //               "dateAndTime": e.dateAndTime,
        //               "location": e.location,
        //               "description": e.description,
        //             })
        //         .toList(),
        //   },
        // );
        // final expectedResponseString = await expectedResponse.readAsString();

        // expect(responseString, equals(expectedResponseString));
        // expect(response.statusCode, equals(expectedResponse.statusCode));

        // cleanup
      },
    );
  });
}

class _MockSearchMatchesUseCase extends Mock implements SearchMatchesUseCase {}

class _MockRequest extends Mock implements Request {}

class _FakeMatchSearchFilterValue extends Fake
    implements MatchSearchFilterValue {}
