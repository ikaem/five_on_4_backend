import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../auth/presentation/router/auth_router.dart';
import '../../../matches/presentation/router/matches_router.dart';

class AppRouter {
  AppRouter({
    required AuthRouter authRouter,
    required MatchesRouter matchesRouter,
  }) : _router = Router() {
    _router.mount("/auth", authRouter.router.call);
    // _router.mount("/auth", authRouter.router.call);
    _router.mount("/matches", matchesRouter.router.call);
    // TODO test only
    // _router.get("/test/<greeting>", testGreeting);
  }

  final Router _router;
  Router get router => _router;
}

testGreeting(Request req, String greeting) async {
  // final secret = "9beSsexjUXBir09LIK9uQ50QSGXCho4gqdAl/L5CAhB";

  // final cookies = req.headers[HttpHeaders.cookieHeader];

  // final cryptWrapper = CryptWrapper(passwordSalt: secret);

  // final storedPassHash =
  //     cryptWrapper.getHashedPassword(password: "hellopass");

  // // TODO make this an extension or something
  // // final bodyString = await req.readAsString();
  // // final body = jsonDecode(bodyString);

  // // final bodyMap = await req.parseBody();

  // final bodyMap = await req.parseBody();

  // final idToken = bodyMap["idToken"];
  // if (idToken is! String) {
  //   return Response.badRequest(
  //     body: jsonEncode({"error": "idToken is required"}),
  //     // encoding: utf8,
  //     headers: {
  //       "Content-Type": "application/json",
  //       // "Set-Cookie": "mycookie=test; HttpOnly; SameSite=Strict; Secure",
  //       "Set-Cookie": [
  //         Cookie("mycookie2", "test").toString(),
  //         Cookie("mycookie3", "test").toString(),
  //       ],
  //     },
  //   );
  // }

  // final providedPass = req.requestedUri.queryParameters["pass"];
  // // final hashedProvidedPass =
  // //     cryptWrapper.getHashedPassword(password: providedPass!);

  // final isMatch = cryptWrapper.checkIfPasswordsMatch(
  //   providedPassword: providedPass!,
  //   hashedPassword: storedPassHash,
  // );

  // final providedPass = req.requestedUri.queryParameters["pass"];

  // // TODO maybe is good to get salt like this too
  // final salt = Crypt.sha256("test", salt: "something");
  // // salt.salt;

  // final myPass = "test";
  // final hashString = "something";

  // final hashedPass = Crypt.sha256(myPass, salt: hashString);

  // print(hashedPass);
  // final encodedPass = utf8.encode(myPass);
  // final pass = sha256.convert(input)

  final cookie = Cookie.fromSetCookieValue(
      "accessToken=sample_access_token; Path=/protected/area; Expires=Wed, 12 Jun 2024 23:59:59 GMT");

  final cookieString = cookie.toString();

  final requestCookies = req.headers[HttpHeaders.cookieHeader];
  log("requestCookies: $requestCookies", name: "AppRouter");
  return Response.ok(
    jsonEncode({"test": "test"}),
    // {
    //   "hello": "hello",
    // },
    headers: {
      "Content-Type": "Application/json",
      HttpHeaders.setCookieHeader: [
        // Cookie("mycookie", "test2").toString(),
        // Cookie.fromSetCookieValue("mycookie=test; HttpOnly; Secure")
        // Cookie.fromSetCookieValue("accessToken=abc123; HttpOnly; Secure")
        Cookie.fromSetCookieValue(
                "access_token=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly")
            .toString(),
        Cookie.fromSetCookieValue(
                "another_cookie_name=your_another_cookie_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly")
            .toString(),
        // Cookie.fromSetCookieValue("accessToken2=abc1233; HttpOnly; Secure")
        // Cookie.fromSetCookieValue(
        //         "accessToken1=sample_access_token1; Path=/protected/area; Expires=Wed, 12 Jun 2024 23:59:59 GMT")
        //     .toString(),
      ]
    },
  );
}


// TODO move to extensions

/* 



request with cookies
curl -b "access_token=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure" \
  -b "another_cookie_name=your_another_cookie_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure" http://localhost:8080/test





 */