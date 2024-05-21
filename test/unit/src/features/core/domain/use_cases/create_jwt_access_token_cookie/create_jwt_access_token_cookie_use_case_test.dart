// import 'dart:io';

// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// import '../../../../../../../../bin/src/features/core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
// import '../../../../../../../../bin/src/wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

// void main() {
//   final dartJsonWebTokenWrapper = _MockDartJsonWebTokenWrapper();

//   final signJwtUseCase = CreateJWTAccessTokenCookieUseCase(
//     dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
//   );

//   setUpAll(() {
//     registerFallbackValue(Duration.zero);
//   });

//   tearDown(() {
//     reset(dartJsonWebTokenWrapper);
//   });

//   group("$CreateJWTAccessTokenCookieUseCase", () {
//     group(".call()", () {
//       test(
//         "given valid payload and expiresIn"
//         "when call() is called "
//         "then should call CreateJWTAccessTokenCookieUseCase.sign and return expected cookie ",
//         () async {
//           // setup
//           when(
//             () => dartJsonWebTokenWrapper.sign(
//               payload: any(named: "payload"),
//               expiresIn: any(named: "expiresIn"),
//             ),
//           ).thenReturn("token");

//           // given
//           final payload = {
//             "key": "value",
//           };
//           final expiresIn = Duration(seconds: 1);

//           // when
//           final cookie = signJwtUseCase.call(
//             payload: payload,
//             expiresIn: expiresIn,
//           );

//           // then
//           final expectedCookie = Cookie.fromSetCookieValue(
//             "accessToken=token; HttpOnly; Secure; Path=/",
//           );
//           expect(cookie.toString(), expectedCookie.toString());
//           verify(
//             () => dartJsonWebTokenWrapper.sign(
//               payload: payload,
//               expiresIn: expiresIn,
//             ),
//           ).called(1);

//           // cleanup
//         },
//       );
//     });
//   });
// }

// class _MockDartJsonWebTokenWrapper extends Mock
//     implements DartJsonWebTokenWrapper {}

// TODO delete