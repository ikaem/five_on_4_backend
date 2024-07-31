import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/validators/request_validator.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/search_players_request_body_key_constants.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class SearchPlayersRequestValidator implements RequestValidator {
  const SearchPlayersRequestValidator();

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) {
    return (Request request) async {
      // TODO make some extension to get this data
      final requestQueryParams = request.url.queryParameters;
      final nameTerm = requestQueryParams[
          SearchPlayersRequestBodyKeyConstants.NAME_TERM.value];

      // final requestBody = await request.parseBody();

      // final nameTerm =
      //     requestBody[SearchPlayersRequestBodyKeyConstants.NAME_TERM.value];

      // TODO for now no validation - it might happen later

      final validatedUrlQueryParamsData = {
        SearchPlayersRequestBodyKeyConstants.NAME_TERM.value: nameTerm,
      };

      final changed = request.getChangedRequestWithValidatedUrlQueryParams(
        validatedUrlQueryParamsData,
      );

      // final changed = request.getChangedRequestWithValidatedBodyData(
      //   validatedBodyData,
      // );

      return validatedRequestHandler(changed);
    };
  }
}
