import 'package:game_shelf/data/models/detailed_game.dart';
import 'package:game_shelf/data/services/games_api_service.dart';
import 'package:game_shelf/utils/api_client.dart';

import '../models/game.dart';
import '../models/game_entity.dart';

class GameRepository {
  final GamesApiService apiService;

  GameRepository(this.apiService);

  Future<Result<List<Game>>> getPopularGames({
    int page = 1,
    int pageSize = 20,
  }) async {
    return apiService.fetchPopularGames(page: page, pageSize: pageSize);
  }

  Future<Result<Game>> getTheSpotlight() async {
    return apiService.fetchSpotlightGame();
  }

  Future<Result<List<Game>>> getRecentlyReleasedGames({
    int page = 1,
    int pageSize = 20,
  }) async {
    return apiService.fetchRecentlyReleasedGames(
      page: page,
      pageSize: pageSize,
    );
  }

  Future<Result<List<Game>>> getTrendingGames({
    int page = 1,
    int pageSize = 20,
  }) async {
    return apiService.fetchTrendingGames(page: page, pageSize: pageSize);
  }

  Future<Result<List<Game>>> searchGames({
    int? pageSize = 10,
    int? page = 1,
    List<int>? platform,
    List<int>? genre,
    String? ordering,
    required String search,
  }) async {
    return apiService.fetchSearch(
      page: page,
      pageSize: pageSize,
      platform: platform,
      genre: genre,
      search: search,
      ordering: ordering
    );
  }

  Future<Result<List<Genre>>> getGenres(){
    return apiService.fetchGenres();
  }

  Future<Result<DetailedGame>> getGameById(int id){
    return apiService.fetchGameById(id);
  }
}
