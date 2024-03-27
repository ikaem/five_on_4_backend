import 'package:drift/drift.dart';

class MatchEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dateAndTime => dateTime()();
  TextColumn get location => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
