import 'package:five_on_4_backend/src/features/players/utils/middlewares/get_player_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/get_player_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group(
    "$GetPlayerRequestMiddlewareWrapper",
    () {
      group(".call()", () {
        test(
          "given [GetPlayerRequestValidator] instance"
          "when [Request] is passed to the middleware"
          "then should call the providerd [GetPlayerRequestValidator.validate()]",
          () async {
            // setup
            final Request request = Request(
              "get",
              Uri.parse("https://example.com/"),
            );

            // given
            final GetPlayerRequestValidator getPlayerRequestValidator =
                _MockGetPlayerRequestValidator();
            when(() => getPlayerRequestValidator.validate(
                    validatedRequestHandler:
                        any(named: "validatedRequestHandler")))
                .thenReturn((request) {
// need to return function here - inner handler
              return (Request request) async {
// we return immediately here from the .validate() - we dont propagate it to the next handler - to validatedRequestHandler, and consequently to the innerHandler of Shelf

                return Response.ok("ok");
              }(request);
            });

            // get the middleware wrapper
            final GetPlayerRequestMiddlewareWrapper middlewareWrapper =
                GetPlayerRequestMiddlewareWrapper(
              getPlayerRequestValidator: getPlayerRequestValidator,
            );

            // get the middleware from the wrapper
            final Middleware middleware = middlewareWrapper.call();

            // get the middleware request handler
            final middlewareRequestHandler = middleware((request) async {
              // we are ok to throw here because call chain should never propagate from here
              // return of response in mocked validator ensures that
              throw Exception("This should not be triggered");
            });

            // when
            // send the request to the middleware request handler
            await middlewareRequestHandler(request);

            // then
            verify(() => getPlayerRequestValidator.validate(
                validatedRequestHandler:
                    any(named: "validatedRequestHandler"))).called(1);

            // cleanup
          },
        );
      });
    },
  );
}

class _MockGetPlayerRequestValidator extends Mock
    implements GetPlayerRequestValidator {}
