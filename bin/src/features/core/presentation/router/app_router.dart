import 'dart:convert';
import 'dart:io';

import 'package:crypt/crypt.dart';
import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../wrappers/libraries/crypt/crypt_wrapper.dart';
import '../../../auth/presentation/router/auth_router.dart';
import '../../utils/extensions/request_extension.dart';

class AppRouter {
  AppRouter({
    required AuthRouter authRouter,
  }) : _router = Router() {
    _router.mount("/auth/", authRouter.router.call);
    // TODO test only
    _router.get("/test", (Request req) async {
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
      final requestCookies = req.headers[HttpHeaders.cookieHeader];
      return Response.ok(
        "test",
        // {
        //   "hello": "hello",
        // },
        headers: {
          "Content-Type": "Application/json",
          HttpHeaders.setCookieHeader: [
            // Cookie("mycookie", "test2").toString(),
            // Cookie.fromSetCookieValue("mycookie=test; HttpOnly; Secure")
            Cookie.fromSetCookieValue("mycookie=tes2tdf").toString(),
          ]
        },
      );
    });
  }

  final Router _router;
  Router get router => _router;
}

// TODO move to extensions