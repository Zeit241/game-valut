import 'package:drift/drift.dart';

enum Status { backlog, playing, completed, dropped, paused }

class LibraryGames extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  DateTimeColumn get released => dateTime().nullable()();

  TextColumn get developer => text()();

  TextColumn get notes => text()();

  BlobColumn get backgroundImage => blob().nullable()();

  IntColumn get rating => integer()
      .check(rating.isSmallerOrEqualValue(5))
      .withDefault(const Constant(0))();

  IntColumn get completion => integer()
      .check(completion.isSmallerOrEqualValue(100))
      .withDefault(const Constant(0))();

  TextColumn get status => textEnum<Status>()();

  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
