import 'package:flutter/foundation.dart';
import 'package:game_shelf/utils/api_client.dart';

import '../../data/models/game.dart';
import '../../data/repositories/game_repository.dart';

class ExploreViewModel extends ChangeNotifier {
  final GameRepository repository;

  ExploreViewModel(this.repository);

  Result<List<Game>>? popularThisWeekGames;
  Result<List<Game>>? trendingNowGames;
  Result<List<Game>>? recentlyReleasedGames;
  Result<Game>? spotlightGame;
  Result<List<Game>>? searchedGames;

  Future<void> loadGames() async {
    _load(repository.getPopularGames, (r) => popularThisWeekGames = r);
    _load(repository.getTrendingGames, (r) => trendingNowGames = r);
    _load(
      repository.getRecentlyReleasedGames,
      (r) => recentlyReleasedGames = r,
    );
    _load(repository.getTheSpotlight, (r) => spotlightGame = r);
  }

  Future<Result<List<Game>>> search(String search) async {
    return await repository.searchGames(search: search, pageSize: 3);
  }

  Future<void> _load<T>(
    Future<Result<T>> Function() request,
    void Function(Result<T>) assign,
  ) async {
    assign(await request());
    notifyListeners();
  }
}
