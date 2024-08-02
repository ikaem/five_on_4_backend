import 'package:equatable/equatable.dart';

class PlayersSearchFilterValue extends Equatable {
  PlayersSearchFilterValue({
    this.nameTerm,
  });

  final String? nameTerm;

  @override
  List<Object?> get props => [nameTerm];
}
