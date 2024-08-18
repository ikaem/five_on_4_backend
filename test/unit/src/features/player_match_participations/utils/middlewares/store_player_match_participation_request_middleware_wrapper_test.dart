import 'package:five_on_4_backend/src/features/player_match_participations/utils/middlewares/store_player_match_participation_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/validators/store_player_match_participate_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group(
    ".call()",
    () {
      test(
        "given [StorePlayerMatchParticipateRequestValidator] instance"
        "when [Request] is passed to the middleware"
        "then should call the provided [StorePlayerMatchParticipateRequestValidator.validate()]",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));

          // given
          final validator = _MockStorePlayerMatchParticipateRequestValidator();
          when(
            () => validator.validate(
              validatedRequestHandler: any(named: "validatedRequestHandler"),
            ),
          ).thenReturn(
            (request) {
              return (Request request) async {
                return Response.ok("ok");
              }(request);
            },
          );

          // get middlewareWrapper
          final middlewareWrapper =
              StorePlayerMatchParticipationRequestMiddlewareWrapper(
            storePlayerMatchParticipateRequestValidator: validator,
          );

          // get middleware from the wrapper
          final middleware = middlewareWrapper.call();

          // get middleware request handler
          final setupRequestHandler = middleware((request) async {
            return Response.ok(
              "Returning from the router-specific handler - request propagates to the request handler.",
            );
          });

          // when
          // send request to the middleware request handler
          await setupRequestHandler(request);

          // then
          // verify that request handler was called
          verify(
            () => validator.validate(
              validatedRequestHandler: any(named: "validatedRequestHandler"),
            ),
          ).called(1);

          // cleanup
        },
      );
    },
  );
}

class _MockStorePlayerMatchParticipateRequestValidator extends Mock
    implements StorePlayerMatchParticipateRequestValidator {}
