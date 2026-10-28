import 'package:flutter/material.dart';
import 'package:game_shelf/data/models/game.dart';
import 'package:game_shelf/data/repositories/game_repository.dart';
import 'package:game_shelf/ui/core/database/app_database.dart';

import '../../data/repositories/library_repository.dart';
import '../../utils/api_client.dart';

class LibraryScreenViewMode extends ChangeNotifier {
  final LibraryRepository _repository;
  final GameRepository _repository2;
  List<LibraryGame>? games;

  int _requestId = 0;
  bool _disposed = false;

  LibraryScreenViewMode(this._repository, this._repository2);

  Future<void> getGames({String? search}) async {
    final requestId = ++_requestId;
    final response = await _repository.getGames(search: search);
    if (_disposed || requestId != _requestId) return;
    games = response;
    notifyListeners();
  }

  Future<Game?> getGameFromApi(int id) async {
    final result = await _repository2.apiService.fetchGameById(id);
    return switch (result) {
      Success(:final data) => data,
      Failure(:final message) => null,
    };
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
