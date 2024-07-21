// import 'dart:io';

// import '../../../../../wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

// // TODO this should do other stuff - this should actually create cookie with jwt token in it

// // TODO this should also delegage to cookies handler wrapper
// // TODO delete this - not needed
// // TODO!!!!!!!!! BUT keep it as reference to how to assemnbe cookie string
// class CreateJWTAccessTokenCookieUseCase {
//   const CreateJWTAccessTokenCookieUseCase({
//     required DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
//   }) : _dartJsonWebTokenWrapper = dartJsonWebTokenWrapper;

//   final DartJsonWebTokenWrapper _dartJsonWebTokenWrapper;
//   // TODO this should accept payload of accesstokendata class as well

//   Cookie call({
//     required Map<String, dynamic> payload,
//     required Duration expiresIn,
//   }) {
//     final token = _dartJsonWebTokenWrapper.sign(
//       payload: payload,
//       expiresIn: expiresIn,
//     );

//     final httpOnly = "HttpOnly";
//     final secure = "Secure";
//     final name = "accessToken";
//     final path = "/";

//     final cookieString = "$name=$token; $httpOnly; $secure; Path=$path";

//     final cookie = Cookie.fromSetCookieValue(cookieString);

//     return cookie;
//   }
// }

// TODO delete