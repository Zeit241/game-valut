import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/library_games.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [LibraryGames])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(driftDatabase(name: 'gamevault'));

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 1;
}