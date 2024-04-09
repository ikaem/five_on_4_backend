// create interface or base class for all controllers

import 'package:shelf/shelf.dart';

import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  GetMatchController({
    required GetMatchUseCase getMatchUseCase,
  }) : _getMatchUseCase = getMatchUseCase;

  final GetMatchUseCase _getMatchUseCase;

  Future<Response> call(Request request) async {
    return Response.ok("Hello, World!");
  }
}
