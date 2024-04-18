import 'package:equatable/equatable.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';

abstract interface class MatchesDataSource {
  Future<MatchEntityData?> getMatch({
    required int matchId,
  });

  Future<int> createMatch({
    required CreateMatchValue createMatchValue,
  });
}

// TODO move to values
class CreateMatchValue extends Equatable {
  CreateMatchValue({
    required this.title,
    required this.dateAndTime,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final String title;
  final int dateAndTime;
  final String location;
  final String description;
  final int createdAt;
  final int updatedAt;

  @override
  List<Object?> get props => [
        title,
        dateAndTime,
        location,
        description,
        createdAt,
        updatedAt,
      ];
}

/* final matchCompanion = MatchEntityCompanion.insert(
  title: title,
  dateAndTime: dateAndTime,
  location: location,
  description: description,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
 */