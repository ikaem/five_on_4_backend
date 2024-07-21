import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/matches/utils/middlewares/get_player_matches_overview_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/utils/validators/get_player_matches_overview_request_validator.dart';

void main() {
  group("$GetPlayerMatchesOverviewRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given GetPlayerMatchesOverviewRequestValidator instance"
        "when request is passed to the middleware"
        "then should call the provided GetPlayerMatchesOverviewRequestValidator.validate()",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));

          // given
          final validator = _MockGetPlayerMatchesOverviewRequestValidator();
          when(() => validator.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).thenReturn((request) {
            return (Request request) async {
              return Response.ok("ok");
            }(request);
          });

          // get middlewareWrapper
          final middlewareWrapper =
              GetPlayerMatchesOverviewRequestMiddlewareWrapper(
            getPlayerMatchesOverviewRequestValidator: validator,
          );

          // get middleware from the wrapper
          final middleware = middlewareWrapper.call();

          // get middleware request handler
          final setupRequestHandler = middleware((request) async {
            return Response.ok(
                "Returning from the router-specific handler - request propagates to the request handler.");
          });

          // when
          // send request to the middleware request handler
          await setupRequestHandler(request);

          // then
          // verify that request handler was called
          verify(() => validator.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockGetPlayerMatchesOverviewRequestValidator extends Mock
    implements GetPlayerMatchesOverviewRequestValidator {}
