import 'package:equatable/equatable.dart';

class MatchSearchFilterValue extends Equatable {
  MatchSearchFilterValue({
    this.matchTitle,
  });

  // TODO in future, there will be more filters here
  final String? matchTitle;

  @override
  List<Object?> get props => [matchTitle];
}
