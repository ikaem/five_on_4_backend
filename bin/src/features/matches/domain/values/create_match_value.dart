// TODO move to values
import 'package:equatable/equatable.dart';

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
