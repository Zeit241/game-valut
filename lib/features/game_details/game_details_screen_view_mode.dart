import 'package:flutter/material.dart';
import 'package:game_shelf/data/models/detailed_game.dart';
import 'package:game_shelf/data/models/game.dart';
import 'package:game_shelf/utils/api_client.dart';

import '../../data/repositories/game_repository.dart';

class GameDetailsScreenViewMode extends ChangeNotifier {
  final GameRepository repository;
  Result<DetailedGame>? game;
  Future<Result<List<Game>>>? similarGames;

  GameDetailsScreenViewMode(this.repository);

  Future<void> load(int id) async {
    final result = await repository.getGameById(id);
    switch (result) {
      case Success<DetailedGame>(:final data):
        loadSimilarGames(data);
      case Failure<DetailedGame>():
        break;
    }
    game = result;

    notifyListeners();
  }

  Future<void> loadSimilarGames(Game game) async {
    final genres = game.genres.map((el) => el.id).toList();
    similarGames = repository.apiService.fetchSearch(
      search: '',
      pageSize: 10,
      page: 1,
      genre: genres,
    );

    notifyListeners();
  }
}
