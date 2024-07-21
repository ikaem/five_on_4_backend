import '../../repositories/matches_repository.dart';
import '../../values/create_match_value.dart';

class CreateMatchUseCase {
  CreateMatchUseCase({
    required MatchesRepository matchesRepository,
  }) : _matchesRepository = matchesRepository;

  final MatchesRepository _matchesRepository;

  Future<int> call({
    required String title,
    required int dateAndTime,
    required String location,
    required String description,
    required int createdAt,
    required int updatedAt,
  }) async {
    final createMatchValue = CreateMatchValue(
      title: title,
      dateAndTime: dateAndTime,
      location: location,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    final id = await _matchesRepository.createMatch(
      createMatchValue: createMatchValue,
    );

    return id;
  }
}
