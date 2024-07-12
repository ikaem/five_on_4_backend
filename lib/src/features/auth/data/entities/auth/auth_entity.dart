import 'package:drift/drift.dart';

class AuthEntity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text()();
  TextColumn get password => text().nullable()();
  TextColumn get authType => text()();
  // TODO how to make these update automatically
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
