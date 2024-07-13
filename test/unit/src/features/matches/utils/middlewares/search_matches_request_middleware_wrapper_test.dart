import 'package:five_on_4_backend/src/features/matches/utils/middlewares/search_matches_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/utils/validators/search_matches_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group("$SearchMatchesRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given SearchMatchesRequestValidator instance"
        "when request is passed to the middleware"
        "then should call the provided SearchMatchesRequestValidator.validate()",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));

          // given
          final searchMatchesRequestValidator =
              _MockSearchMatchesRequestValidator();
          when(() => searchMatchesRequestValidator.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).thenReturn((request) {
            return (Request request) async {
              // we return immediately here from the .validate() - we dont propagate it to the next handler - to validatedRequestHandler, and consequently to the innerHandler of Shelf
              return Response.ok("ok");
            }(request);
          });

          // get the middleware wrapper
          final middlewareWrapper = SearchMatchesRequestMiddlewareWrapper(
            searchMatchesRequestValidator: searchMatchesRequestValidator,
          );

          // get the middleware from the wrapper
          final middleware = middlewareWrapper.call();

          // get the middleware request handler
          final setupRequestHandler = middleware((request) async {
            // request will not propagate to this handler - because we return immediately from the .validate()
            return Response.ok(
                "Returning from the router-specific handler - request propagates to the request handler.");
          });

          // when
          // send request to the middleware request handler
          await setupRequestHandler(request);

          // then
          // verify that the validator was called
          verify(() => searchMatchesRequestValidator.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockSearchMatchesRequestValidator extends Mock
    implements SearchMatchesRequestValidator {}
