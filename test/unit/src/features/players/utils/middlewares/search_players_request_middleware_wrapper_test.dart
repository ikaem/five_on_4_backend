import 'package:five_on_4_backend/src/features/players/utils/middlewares/search_players_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/search_players_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group(
    "$SearchPlayersRequestMiddlewareWrapper",
    () {
      group(
        ".call()",
        () {
          test(
            "given [SearchPlayersRequestValidator] instance"
            "when request is passed to the middleware"
            "then should call the providerd [SearchPlayersRequestValidator.validate()]",
            () async {
              // setup
              final request = Request("get", Uri.parse("https://example.com/"));

              // given
              final searchPlayersRequestValidator =
                  _MockSearchPlayersRequestValidator();
              when(
                () => searchPlayersRequestValidator.validate(
                  validatedRequestHandler:
                      any(named: "validatedRequestHandler"),
                ),
              ).thenReturn(
                (request) {
                  return (Request request) async {
                    // we return immediately here from the .validate() - we dont propagate it to the next handler - to validatedRequestHandler, and consequently to the innerHandler of Shelf
                    return Response.ok("ok");
                  }(
                    request,
                  );
                },
              );

              // get the middleware wrapper
              final middlewareWrapper = SearchPlayersRequestMiddlewareWrapper(
                searchPlayersRequestValidator: searchPlayersRequestValidator,
              );

              // get the middleware from the wrapper
              final middleware = middlewareWrapper.call();

              // get the middleware request handler
              final setupRequestHandler = middleware(
                (request) async {
                  // request will not propagate to this handler - because we return immediately from the .validate()
                  // return Response.ok(
                  //   "Returning from the router-specific handler - request propagates to the request handler.",
                  // );
                  // NOTE: This should normallyreturn Response, but lets throw to make sure this is not triggered?
                  throw Exception("This should not be triggered");
                },
              );

              // when
              // send request to the middleware request handler
              await setupRequestHandler(
                request,
              );

              // then
              // verify that the validator was called
              // TODO how could we test here that specific request maybe was passed to validated request handler - opr maybe we dont care?
              verify(
                () => searchPlayersRequestValidator.validate(
                  validatedRequestHandler:
                      any(named: "validatedRequestHandler"),
                ),
              ).called(1);

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockSearchPlayersRequestValidator extends Mock
    implements SearchPlayersRequestValidator {}
