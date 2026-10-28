import 'package:drift/drift.dart';
import 'package:game_shelf/data/services/games_api_service.dart';
import 'package:game_shelf/ui/core/database/tables/library_games.dart';

import '../../ui/core/database/app_database.dart';
import '../models/game.dart';

class LibraryRepository {
  final AppDatabase _database;

  LibraryRepository(this._database);

  Future<void> addGame({
    required Game game,
    required Status status,
    int? rating,
    int? completion,
    String? notes,
  }) async {
    final developers = game.developers;
    final existing = await getGameById(game.id);
    final image =
        existing?.backgroundImage ??
        await GamesApiService.imageUrlToBytes(game.backgroundImage);
    await _database
        .into(_database.libraryGames)
        .insertOnConflictUpdate(
          LibraryGamesCompanion.insert(
            id: Value(game.id),
            name: game.name,
            developer: developers.isNotEmpty ? developers.first.name : '',
            completion: Value(completion ?? 0),
            rating: Value(rating ?? 0),
            notes: notes ?? '',
            status: status,
            backgroundImage: Value(image),
            endedAt: Value(status == Status.completed ? DateTime.now() : null),
          ),
        );
  }


  Future<LibraryGame?> getGameById(int id) {
    return (_database.select(_database.libraryGames)
          ..where((game) => game.id.equals(id)))
        .getSingleOrNull();
  }


  // Получить все игры библиотеки
  Future<List<LibraryGame>> getGames({String? search}) {
    final db = _database.select(_database.libraryGames);
    final term = search?.trim();

    if (term != null && term.isNotEmpty) {
      db.where(
        (game) => game.name.contains(term) | game.developer.contains(term),
      );
    }

    return db.get();
  }

  // Наблюдать за библиотекой в реальном времени
  Stream<List<LibraryGame>> watchGames() {
    return _database.select(_database.libraryGames).watch();
  }

  // Удалить игру
  Future<void> removeGame(int id) {
    return (_database.delete(
      _database.libraryGames,
    )..where((game) => game.id.equals(id))).go();
  }

  // Изменить статус прохождения
  // Future<void> updateStatus(int id, String status) {
  //   return (_database.update(_database.libraryGames)
  //     ..where((game) => game.id.equals(id)))
  //       .write(
  //     LibraryGamesCompanion(
  //       status: Value(status),
  //     ),
  //   );
  // }
  //
  // // Добавить в избранное / убрать из избранного
  // Future<void> setFavorite(int id, bool isFavorite) {
  //   return (_database.update(_database.libraryGames)
  //     ..where((game) => game.id.equals(id)))
  //       .write(
  //     LibraryGamesCompanion(
  //       isFavorite: Value(isFavorite),
  //     ),
  //   );
  // }
}
