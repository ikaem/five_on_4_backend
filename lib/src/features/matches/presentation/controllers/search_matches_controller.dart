import 'dart:io';

import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/helpers/response_generator.dart';
import 'package:five_on_4_backend/src/features/matches/domain/models/match_model.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/search_matches/search_matches_use_case.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/match_search_filter_value.dart';
import 'package:five_on_4_backend/src/features/matches/utils/constants/search_matches_request_body_key_constants.dart';
import 'package:shelf/shelf.dart';

class SearchMatchesController {
  const SearchMatchesController({
    required SearchMatchesUseCase searchMatchesUseCase,
  }) : _searchMatchesUseCase = searchMatchesUseCase;

  final SearchMatchesUseCase _searchMatchesUseCase;

  Future<Response> call(Request request) async {
    // TODO this data is probably better to be in query params. that way we can make the route a GET one, which would make more sense
    // TODO make this as a TICKET at some point
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final response = ResponseGenerator.failure(
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final matchTitle = validatedBodyData[
        SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value] as String?;

    final MatchSearchFilterValue matchSearchFilterValue =
        MatchSearchFilterValue(
      matchTitle: matchTitle,
    );

    final matches = await _searchMatchesUseCase(
      filter: matchSearchFilterValue,
    );

    final response = ResponseGenerator.success(
      // TODO maybe Searched matches retrieved successfully.
      message: "Matches searched successfully.",
      data: _generateOkResponseData(
        matches: matches,
      ),
    );

    return response;
  }
}

Map<String, Object> _generateOkResponseData({
  required List<MatchModel> matches,
}) {
  final payloadMatches = matches
      .map((e) => ({
            "id": e.id,
            "title": e.title,
            "dateAndTime": e.dateAndTime,
            "location": e.location,
            "description": e.description,
          }))
      .toList();

  return {
    "matches": payloadMatches,
    // TODO this is proof of concept
    // TODO this will need pagination data
    // "pagination": {
    //   "total": payloadMatches.length,
    //   "page": 1,
    //   "perPage": 10,
    // },
  };
}
