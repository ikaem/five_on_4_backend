import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/matches/data/data_sources/matches_data_source_impl.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/player_match_participation_entity_value.dart';

class MatchEntityValue extends Equatable {
  const MatchEntityValue({
    required this.id,
    required this.title,
    required this.dateAndTime,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.participtions,
  });

  final int id;
  final String title;
  final DateTime dateAndTime;
  final String location;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PlayerMatchParticipationEntityValue> participtions;

  @override
  List<Object?> get props => [
        id,
        title,
        dateAndTime,
        location,
        description,
        createdAt,
        updatedAt,
      ];
}
