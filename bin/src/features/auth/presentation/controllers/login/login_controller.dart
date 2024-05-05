import 'package:shelf/shelf.dart';

class LoginController {
  Future<Response> call(Request request) async {
    return Response.ok('Hello, World!');
  }
}
