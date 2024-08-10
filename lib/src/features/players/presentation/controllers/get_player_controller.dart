import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class GetPlayerController {
  const GetPlayerController();

// TODO temp only this
  Future<Response> call(Request request) async {
    final params = request.params;

    final id = params["id"];

    print("request: $request");
    return Response(200);
  }
}
