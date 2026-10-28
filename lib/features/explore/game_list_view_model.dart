import 'package:flutter/foundation.dart';

import '../../data/models/game.dart';
import '../../data/repositories/game_repository.dart';
import '../../routing/router.dart';
import '../../utils/api_client.dart';

class GameListViewModel extends ChangeNotifier {
  GameListViewModel(this.repository, this.kind);

  final GameRepository repository;
  final GameListKind kind;

  static const pageSize = 20;

  Result<List<Game>>? games;
  int page = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  Future<void> load() async {
    page = 1;
    hasMore = true;
    final result = await _fetch(page);
    if (result case Success(:final data)) {
      hasMore = data.length == pageSize;
    }
    games = result;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore || games is! Success) return;
    isLoadingMore = true;
    notifyListeners();
    final result = await _fetch(page + 1);
    switch (result) {
      case Success(:final data):
        page++;
        final current = (games as Success<List<Game>>).data;
        final count = (games as Success<List<Game>>).count;
        games = Success(data: [...current, ...data], count: count);
        hasMore = data.length == pageSize;
      case Failure():
        break;
    }
    isLoadingMore = false;
    notifyListeners();
  }

  Future<Result<List<Game>>> _fetch(int page) async {
    return switch (kind) {
      GameListKind.trending => repository.getTrendingGames(page: page, pageSize: pageSize),
      GameListKind.popular => repository.getPopularGames(page: page, pageSize: pageSize),
      GameListKind.recentlyReleased => repository.getRecentlyReleasedGames(page: page, pageSize: pageSize),
    };
  }
}
