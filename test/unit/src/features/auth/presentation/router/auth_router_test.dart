import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../../../../../bin/src/features/auth/presentation/controllers/logout/logout_controller.dart';
import '../../../../../../../bin/src/features/auth/presentation/controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';
import '../../../../../../../bin/src/features/auth/presentation/router/auth_router.dart';

void main() {
// controllers
  final googleLoginController = _MockGoogleLoginController();
  final registerWithEmailAndPasswordController =
      _MockRegisterWithEmailAndPasswordController();
  final logoutController = _MockLogoutController();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  setUp(() {
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
  });

  group("$AuthRouter", () {
    group("post /google-login", () {
      final realRequest =
          Request("POST", Uri.parse("https://example.com/google-login"));

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

class _FakeRequest extends Fake implements Request {}
