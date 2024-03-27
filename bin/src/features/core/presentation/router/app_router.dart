import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../wrappers/libraries/crypt/crypt_wrapper.dart';
import '../../../auth/presentation/router/auth_router.dart';

class AppRouter {
  AppRouter({
    required AuthRouter authRouter,
  }) : _router = Router() {
    _router.mount("/auth/", authRouter.router.call);
    // TODO test only
    _router.get("/test", (Request req) async {
      final secret = "9beSsexjUXBir09LIK9uQ50QSGXCho4gqdAl/L5CAhB";

      final cryptWrapper = CryptWrapper(passwordSalt: secret);

      final storedPassHash =
          cryptWrapper.getHashedPassword(password: "hellopass");

      final providedPass = req.requestedUri.queryParameters["pass"];
      // final hashedProvidedPass =
      //     cryptWrapper.getHashedPassword(password: providedPass!);

      final isMatch = cryptWrapper.checkIfPasswordsMatch(
        providedPassword: providedPass!,
        hashedPassword: storedPassHash,
      );

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
      return Response.ok("test");
    });
  }

  final Router _router;
  Router get router => _router;
}
