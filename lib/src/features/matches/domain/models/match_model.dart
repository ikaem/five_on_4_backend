import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/models/player_match_participation_model.dart';

class MatchModel extends Equatable {
  const MatchModel({
    required this.id,
    required this.title,
    required this.dateAndTime,
    required this.location,
    required this.description,
    required this.participations,
  });

  final int id;
  final String title;
  final int dateAndTime;
  final String location;
  final String description;
  final List<PlayerMatchParticipationModel> participations;

  @override
  List<Object?> get props => [
        id,
        title,
        dateAndTime,
        location,
        description,
        participations,
      ];
}
