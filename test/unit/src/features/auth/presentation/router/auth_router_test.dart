import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../../../../../bin/src/features/auth/presentation/controllers/logout/logout_controller.dart';
import '../../../../../../../bin/src/features/auth/presentation/controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';
import '../../../../../../../bin/src/features/auth/presentation/router/auth_router.dart';
import '../../../../../../../bin/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import '../../../../../../../bin/src/features/auth/utils/middlewares/register_with_email_and_password_request_middleware_wrapper.dart';

void main() {
// controllers
  final googleLoginController = _MockGoogleLoginController();
  final registerWithEmailAndPasswordController =
      _MockRegisterWithEmailAndPasswordController();
  final logoutController = _MockLogoutController();

// validators
  final registerWithEmailAndPasswordRequestHandler =
      _MockMiddlewareRequestHandlerCallback();
  final authorizeRequestHandler = _MockMiddlewareRequestHandlerCallback();

  // middleware
  final registerWithEmailAndPasswordRequestMiddlewareWrapper =
      _MockRegisterWithEmailAndPasswordRequestMiddlewareWrapper();
  final authorizeRequestMiddlewareWrapper =
      _MockAuthorizeRequestMiddlewareWrapper();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  setUp(() {
    // validators
    when(() => registerWithEmailAndPasswordRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });
    when(() => authorizeRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });

    // middlewares
    when(() => registerWithEmailAndPasswordRequestMiddlewareWrapper.call())
        .thenReturn(
      createMiddleware(
        requestHandler: registerWithEmailAndPasswordRequestHandler.call,
      ),
    );
    when(() => authorizeRequestMiddlewareWrapper.call()).thenReturn(
      createMiddleware(
        requestHandler: authorizeRequestHandler.call,
      ),
    );

    // controllers
    when(() => googleLoginController.call(any()))
        .thenAnswer((invocation) async {
      return Response.ok("ok");
    });
    when(() => registerWithEmailAndPasswordController.call(any()))
        .thenAnswer((invocation) async {
      return Response.ok("ok");
    });
    when(() => logoutController.call(any())).thenAnswer((invocation) async {
      return Response.ok("ok");
    });
  });

  tearDown(() {
    reset(googleLoginController);
    reset(registerWithEmailAndPasswordController);
    reset(logoutController);
    reset(registerWithEmailAndPasswordRequestMiddlewareWrapper);
    reset(authorizeRequestMiddlewareWrapper);
    reset(registerWithEmailAndPasswordRequestHandler);
    reset(authorizeRequestHandler);
  });

  group("$AuthRouter", () {
    group(
      "post /logout",
      () {
        final realRequest =
            Request("post", Uri.parse("https://example.com/logout"));

        test(
          "given LogoutController instance"
          "when a request to the endpoint is made"
          "then should call the LogoutController's request handler",
          () async {
            // setup
            final authRouter = AuthRouter(
              googleLoginController: googleLoginController,
              registerWithEmailAndPasswordController:
                  registerWithEmailAndPasswordController,
              logoutController: logoutController,
              registerWithEmailAndPasswordRequestMiddlewareWrapper:
                  registerWithEmailAndPasswordRequestMiddlewareWrapper,
              authorizeRequestMiddlewareWrapper:
                  authorizeRequestMiddlewareWrapper,
            );

            // given

            // when
            await authRouter.router(realRequest);

            // then
            final captured =
                verify(() => logoutController.call(captureAny())).captured;
            final capturedRequest = captured.first as Request;

            expect(capturedRequest.method, equals(realRequest.method));
            expect(capturedRequest.url, equals(realRequest.url));

            // cleanup
          },
        );

        test(
          "given AuthorizeRequestMiddlewareWrapper instance"
          "when a request to the endpoint is made"
          "then should call the AuthorizeRequestMiddlewareWrapper's request handler",
          () async {
            // setup
            final authRouter = AuthRouter(
              googleLoginController: googleLoginController,
              registerWithEmailAndPasswordController:
                  registerWithEmailAndPasswordController,
              logoutController: logoutController,
              registerWithEmailAndPasswordRequestMiddlewareWrapper:
                  registerWithEmailAndPasswordRequestMiddlewareWrapper,
              authorizeRequestMiddlewareWrapper:
                  authorizeRequestMiddlewareWrapper,
            );

            // given

            // when
            await authRouter.router(realRequest);

            // then
            final captured = verify(
              () => authorizeRequestHandler.call(captureAny()),
            ).captured;
            final capturedRequest = captured.first as Request;

            expect(capturedRequest.method, equals(realRequest.method));
            expect(capturedRequest.url, equals(realRequest.url));

            // cleanup
          },
        );
      },
    );
    group(
      "post /register",
      () {
        final realRequest =
            Request("post", Uri.parse("https://example.com/register"));
        test(
          "given RegisterWithEmailAndPasswordController instance"
          "when a request to the endpoint is made"
          "then should call the RegisterWithEmailAndPasswordController's request handler",
          () async {
            // setup
            final authRouter = AuthRouter(
              googleLoginController: googleLoginController,
              registerWithEmailAndPasswordController:
                  registerWithEmailAndPasswordController,
              logoutController: logoutController,
              registerWithEmailAndPasswordRequestMiddlewareWrapper:
                  registerWithEmailAndPasswordRequestMiddlewareWrapper,
              authorizeRequestMiddlewareWrapper:
                  authorizeRequestMiddlewareWrapper,
            );

            // given

            // when
            await authRouter.router(realRequest);

            // then
            final captured = verify(
              () => registerWithEmailAndPasswordController.call(captureAny()),
            ).captured;
            final capturedRequest = captured.first as Request;

            expect(capturedRequest.method, equals(realRequest.method));
            expect(capturedRequest.url, equals(realRequest.url));

            // cleanup
          },
        );

        test(
          "given RegisterWithEmailAndPasswordRequestMiddlewareWrapper instance"
          "when a request to the endpoint is made"
          "then should call the RegisterWithEmailAndPasswordRequestMiddlewareWrapper's request handler",
          () async {
            // setup
            final authRouter = AuthRouter(
              googleLoginController: googleLoginController,
              registerWithEmailAndPasswordController:
                  registerWithEmailAndPasswordController,
              logoutController: logoutController,
              registerWithEmailAndPasswordRequestMiddlewareWrapper:
                  registerWithEmailAndPasswordRequestMiddlewareWrapper,
              authorizeRequestMiddlewareWrapper:
                  authorizeRequestMiddlewareWrapper,
            );

            // given

            // when
            await authRouter.router(realRequest);

            // then
            final captured = verify(
              () =>
                  registerWithEmailAndPasswordRequestHandler.call(captureAny()),
            ).captured;
            final capturedRequest = captured.first as Request;

            expect(capturedRequest.method, equals(realRequest.method));
            expect(capturedRequest.url, equals(realRequest.url));

            // cleanup
          },
        );
      },
    );
    group("post /google-login", () {
      final realRequest =
          Request("post", Uri.parse("https://example.com/google-login"));

      test(
        "given GoogleLoginController instance"
        "when a request to the endpoint is made"
        "then should call the GoogleLoginController's request handler",
        () async {
          // setup
          final authRouter = AuthRouter(
            googleLoginController: googleLoginController,
            registerWithEmailAndPasswordController:
                registerWithEmailAndPasswordController,
            logoutController: logoutController,
            registerWithEmailAndPasswordRequestMiddlewareWrapper:
                registerWithEmailAndPasswordRequestMiddlewareWrapper,
            authorizeRequestMiddlewareWrapper:
                authorizeRequestMiddlewareWrapper,
          );

          // given

          // when
          await authRouter.router(realRequest);

          // then
          final captured =
              verify(() => googleLoginController.call(captureAny())).captured;
          final capturedRequest = captured.first as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );
    });
  });
}

class _MockGoogleLoginController extends Mock
    implements GoogleLoginController {}

class _MockRegisterWithEmailAndPasswordController extends Mock
    implements RegisterWithEmailAndPasswordController {}

class _MockLogoutController extends Mock implements LogoutController {}

class _MockRegisterWithEmailAndPasswordRequestMiddlewareWrapper extends Mock
    implements RegisterWithEmailAndPasswordRequestMiddlewareWrapper {}

class _MockAuthorizeRequestMiddlewareWrapper extends Mock
    implements AuthorizeRequestMiddlewareWrapper {}

class _MockMiddlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
