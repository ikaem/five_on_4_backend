import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/generate_response.dart';
import '../constants/login_request_body_key_constants.dart';
import '../validators/login_request_validator.dart';

class LoginRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const LoginRequestMiddlewareWrapper({
    // required FutureOr<Response?> Function(Request request)? requestHandler,
    required LoginRequestValidator loginRequestValidator,
  }) : _loginRequestValidator = loginRequestValidator;

  // _requestHandler = requestHandler;

  // final FutureOr<Response?> Function(Request request)? _requestHandler;

  final LoginRequestValidator _loginRequestValidator;

  @override
  Middleware call() {
    // final middleware = createMiddleware(
    //   requestHandler: _requestHandler,
    // );
    // return middleware;

    Future<Response> Function(Request) middleware(
      FutureOr<Response> Function(Request) innerHandler,
    ) {
      Future<Response> validatedRequestHandler(Request validatedRequest) async {
        return Future.sync(() => innerHandler(validatedRequest))
            .then((Response response) {
          return response;
        });
      }

      // return (Request request) {
      //   return Future.sync(() => innerHandler(request)).then((response) {
      //     return response;
      //   });
      // };

      return _loginRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );

      // return validator(validatedRequestHandler: validatedRequestHandler);
    }

    return middleware;

// TODO this works
    // Future<Response> Function(Request) middleware(
    //   FutureOr<Response> Function(Request) innerHandler,
    // ) {
    //   Future<Response> validator(Request request) async {
    //     final changedRequest = request.change(context: {"email": "email"});

    //     Future<Response> validatedRequestHandler() async {
    //       return Future.sync(() => innerHandler(changedRequest))
    //           .then((Response response) {
    //         return response;
    //       });
    //     }

    //     return validatedRequestHandler();

    //     // final forwardedRequestHandler =
    //     //     Future.sync(() => innerHandler(changedRequest))
    //     //         .then((Response response) {
    //     //   return response;
    //     // });

    //     // return forwardedRequestHandler;
    //   }

    //   return validator;
    // }
  }
}

// lets create a function that will validate
// this function needs to be returned - so its result needs to be returned

// it can return a response directly

// or it can return a function that will return a response
// - this function needs to be passed to this function
// - this function will accept a request to be passed to it
// - this function will only be return from this wrapper function if validation passes

// Future<Response> Function(Request) validator({
//   required FutureOr<Response> Function(Request validatedRequest)
//       validatedRequestHandler,
// }) =>
//     (Request request) async {
//       final requestBody = await request.parseBody();

//       // email
//       final email = requestBody[LoginRequestBodyKeyConstants.EMAIL.value];
//       if (email == null) {
//         final responseBody = ResponseBodyValue(
//           message: "Email is required.",
//           ok: false,
//         );
//         return generateResponse(
//           statusCode: HttpStatus.badRequest,
//           body: responseBody,
//           cookies: [],
//         );
//       }

//       if (email is! String) {
//         final responseBody = ResponseBodyValue(
//           message: "Invalid data type supplied for email.",
//           ok: false,
//         );
//         return generateResponse(
//           statusCode: HttpStatus.badRequest,
//           body: responseBody,
//           cookies: [],
//         );
//       }

//       final isValidEmail = checkIsValidEmail(email);
//       if (!isValidEmail) {
//         final responseBody = ResponseBodyValue(
//           message: "Invalid email.",
//           ok: false,
//         );
//         return generateResponse(
//           statusCode: HttpStatus.badRequest,
//           body: responseBody,
//           cookies: [],
//         );
//       }

//       // password
//       final password = requestBody[LoginRequestBodyKeyConstants.PASSWORD.value];
//       if (password == null) {
//         final responseBody = ResponseBodyValue(
//           message: "Password is required.",
//           ok: false,
//         );
//         return generateResponse(
//           statusCode: HttpStatus.badRequest,
//           body: responseBody,
//           cookies: [],
//         );
//       }

//       if (password is! String) {
//         final responseBody = ResponseBodyValue(
//           message: "Invalid data type supplied for password.",
//           ok: false,
//         );
//         return generateResponse(
//           statusCode: HttpStatus.badRequest,
//           body: responseBody,
//           cookies: [],
//         );
//       }

//       // TODO there could be a function or a class to do this
//       final bodyData = {
//         LoginRequestBodyKeyConstants.EMAIL.value: "email",
//         LoginRequestBodyKeyConstants.PASSWORD.value: "password",
//       };

//       final changedRequest = request.change(context: {"bodyData": bodyData});

//       return validatedRequestHandler(changedRequest);
//     };

// checkIsValidEmail(String email) {
//   return true;
// }



// Future<Response> Function(Request request) validator({
  
// }) => (Request request) async {
//   final body = await request.parseBody();

//   // email
//   final email = body[LoginRequestBodyKeyConstants.EMAIL.value];
//   if (email == null) {
//     final responseBody = ResponseBodyValue(
//       message: "Email is required.",
//       ok: false,
//     );
//     return generateResponse(
//       statusCode: HttpStatus.badRequest,
//       body: responseBody,
//       cookies: [],
//     );
//   }

//   if (email is! String) {
//     final responseBody = ResponseBodyValue(
//       message: "Invalid data type supplied for email.",
//       ok: false,
//     );
//     return generateResponse(
//       statusCode: HttpStatus.badRequest,
//       body: responseBody,
//       cookies: [],
//     );
//   }

//   final isValidEmail = checkIsValidEmail(email);
//   if (!isValidEmail) {
//     final responseBody = ResponseBodyValue(
//       message: "Invalid email.",
//       ok: false,
//     );
//     return generateResponse(
//       statusCode: HttpStatus.badRequest,
//       body: responseBody,
//       cookies: [],
//     );
//   }

//   // password
//   final password = body[LoginRequestBodyKeyConstants.PASSWORD.value];
//   if (password == null) {
//     final responseBody = ResponseBodyValue(
//       message: "Password is required.",
//       ok: false,
//     );
//     return generateResponse(
//       statusCode: HttpStatus.badRequest,
//       body: responseBody,
//       cookies: [],
//     );
//   }

//   if (password is! String) {
//     final responseBody = ResponseBodyValue(
//       message: "Invalid data type supplied for password.",
//       ok: false,
//     );
//     return generateResponse(
//       statusCode: HttpStatus.badRequest,
//       body: responseBody,
//       cookies: [],
//     );
//   }

//   final changedRequest = request.change(context: {"email": "email"});
// }

// bool checkIsValidEmail(String email) {
//   return true;
// }
