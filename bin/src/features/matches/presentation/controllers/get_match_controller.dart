// create interface or base class for all controllers

import 'package:shelf/shelf.dart';

import '../../../auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  GetMatchController({
    required GetMatchUseCase getMatchUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
  })  : _getMatchUseCase = getMatchUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase;

  final GetMatchUseCase _getMatchUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;

  Future<Response> call(Request request) async {
    return Response.ok("Hello, World!");
  }
}
