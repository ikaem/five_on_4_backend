import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/validators/request_validator.dart';
import 'package:five_on_4_backend/src/features/matches/utils/constants/search_matches_request_body_key_constants.dart';
import 'package:shelf/shelf.dart';

class SearchMatchesRequestValidator implements RequestValidator {
  const SearchMatchesRequestValidator();

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) {
    return (Request request) async {
      final requestBody = await request.parseBody();

      final matchTitle =
          requestBody[SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value];

      // TODO for now no validation - it might happen later

      final validatedBodyData = {
        SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value: matchTitle,
      };

      final changed = request.getChangedRequestWithValidatedBodyData(
        validatedBodyData,
      );

      return validatedRequestHandler(changed);
    };
  }
}
