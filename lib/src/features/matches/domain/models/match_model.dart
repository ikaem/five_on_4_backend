import 'package:equatable/equatable.dart';

class MatchModel extends Equatable {
  const MatchModel({
    required this.id,
    required this.title,
    required this.dateAndTime,
    required this.location,
    required this.description,
  });

  final int id;
  final String title;
  final int dateAndTime;
  final String location;
  final String description;

  @override
  List<Object?> get props => [
        id,
        title,
        dateAndTime,
        location,
        description,
      ];
}
