import 'package:flutter/material.dart';

import '../../data/models/game.dart';
import '../../data/models/game_entity.dart';
import '../../data/repositories/game_repository.dart';
import '../../utils/api_client.dart';

class SearchViewModel extends ChangeNotifier {
  final GameRepository repository;

  static const pageSize = 20;

  Result<List<Game>>? games;
  Result<List<Genre>>? genres;
  int page = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? search;
  Map<String, List<int>>? filters;
  String? ordering;

  SearchViewModel(this.repository);

  Future<Result<List<Game>>> _fetch({
    required int page,
    String? search,
    Map<String, List<int>>? filters,
    String? ordering = 'relevance',
  }) async {
    final List<int> platforms = filters?['platforms'] ?? [];
    final List<int> genres = filters?['genres'] ?? [];

    return await repository.searchGames(
      search: search ?? '',
      pageSize: pageSize,
      page: page,
      platform: platforms,
      genre: genres,
      ordering: ordering != 'relevance' ? ordering : '',
    );
  }

  Future<void> load({
    String? search,
    Map<String, List<int>>? filters,
    String? ordering,
  }) async {
    this.search = search;
    this.filters = filters;
    this.ordering = ordering;
    page = 1;
    hasMore = true;
    final result = await _fetch(
      page: page,
      search: search,
      filters: filters,
      ordering: ordering,
    );
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
    final result = await _fetch(
      page: page + 1,
      search: search,
      filters: filters,
      ordering: ordering ?? 'relevance',
    );
    switch (result) {
      case Success(:final data):
        page++;
        final current = (games as Success<List<Game>>).data;
        // final
        games = Success(data: [
          ...current,
          ...data,
        ], count: (games as Success<List<Game>>).count);
        hasMore = data.length == pageSize;
      case Failure():
        break;
    }
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadGenres() async {
    final result = await repository.getGenres();
    genres = result;
    notifyListeners();
  }
}
