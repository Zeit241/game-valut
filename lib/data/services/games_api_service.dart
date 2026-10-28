import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:game_shelf/data/models/detailed_game.dart';
import 'package:game_shelf/data/models/game_entity.dart';

import '../../utils/api_client.dart';
import '../models/game.dart';

class GamesApiService {
  Future<Result<Game>> fetchSpotlightGame() async {
    try {
      final response = await ApiClient.dio.get(
        '/games',
        queryParameters: {'ids': 972995, 'page_size': 1},
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      final count = data['count'] as int;
      if (results.isEmpty) {
        return const Failure('Не удалось загрузить игру.');
      }
      return Success(
        data: Game.fromJson(results.first as Map<String, dynamic>),
        count: count,
      );
    } on DioException catch (e) {
      return Failure(_message(e));
    } catch (_) {
      return const Failure('Не удалось загрузить игру.');
    }
  }

  Future<Result<List<Game>>> fetchTrendingGames({
    int? pageSize = 10,
    int page = 1,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        '/games',
        queryParameters: {
          'page_size': pageSize,
          'page': page,
          'ordering': '-added',
          'exclude_additions': 'true',
        },
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      final count = data['count'] as int;
      final games = results
          .map((item) => Game.fromJson(item as Map<String, dynamic>))
          .toList();
      return Success(data: games, count: count);
    } on DioException catch (e) {
      return Failure(_message(e));
    } catch (_) {
      return const Failure('Не удалось загрузить игры.');
    }
  }

  Future<Result<List<Game>>> fetchSearch({
    int? pageSize = 10,
    int? page = 1,
    Map<String, String>? params,
    List<int>? platform,
    List<int>? genre,
    String? ordering,
    required String search,
  }) async {
    try {
      final queryParameters = {
        'page_size': pageSize,
        'page': page,
        'exclude_additions': 'true',
        'search': search ?? '',
        'ordering': ?ordering,
        if (platform != null && platform.isNotEmpty)
          'parent_platforms': platform.join(','),
        if (genre != null && genre.isNotEmpty) 'genres': genre.join(','),
      };

      print(queryParameters);

      final response = await ApiClient.dio.get(
        '/games',
        queryParameters: queryParameters,
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      final count = data['count'] as int;
      final games = results
          .map((item) => Game.fromJson(item as Map<String, dynamic>))
          .toList();
      return Success(data: games, count: count);
    } on DioException catch (e) {
      return Failure(_message(e));
    } catch (_) {
      return const Failure('Не удалось загрузить игры.');
    }
  }

  Future<Result<List<Game>>> fetchRecentlyReleasedGames({
    int? pageSize = 10,
    int page = 1,
  }) async {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 90));

    String dateFormat(DateTime date) =>
        '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    final params = {
      'page_size': pageSize,
      'page': page,
      'dates': '${dateFormat(from)},${dateFormat(now)}',
      'ordering': '-added',
      'exclude_additions': 'true',
    };

    try {
      final response = await ApiClient.dio.get(
        '/games',
        queryParameters: params,
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      final count = data['count'] as int;
      final games = results
          .map((item) => Game.fromJson(item as Map<String, dynamic>))
          .toList();
      return Success(data: games, count: count);
    } on DioException catch (e) {
      return Failure(_message(e));
    } catch (_) {
      return const Failure('Не удалось загрузить игры.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameScreenshotsById(int id) async {
    try {
      final response = await ApiClient.dio.get('/games/$id/screenshots');
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? const [];
      return [
        for (final item in results)
          if (item is Map && item['hidden'] != true)
            Map<String, dynamic>.from(item),
      ];
    } on DioException {
      return [];
    }
  }

 static Future<Uint8List> imageUrlToBytes(String url) async {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data!);
  }

  Future<Result<DetailedGame>> fetchGameById(int id) async {
    try {
      List<Map<String, dynamic>>? screens;
      final response = await ApiClient.dio.get('/games/$id');
      final data = response.data as Map<String, dynamic>;

      if (data['screenshots_count'] != null && data['screenshots_count'] > 0) {
        screens = await fetchGameScreenshotsById(id);
      }

      return Success(
        data: DetailedGame.fromJson(data, screenshots: screens),
      );
    } on DioException catch (e) {
      return Failure(_message(e));
    }
  }

  Future<Result<List<Genre>>> fetchGenres() async {
    try {
      final response = await ApiClient.dio.get(
        '/genres',
        queryParameters: {
          'page': 1,
          'ordering': 'games_count',
          'page_size': 15,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      final count = data['count'] as int;
      final genres = results
          .map((item) => GameEntity.fromJson(item as Map<String, dynamic>))
          .toList();
      return Success(data: genres, count: count);
    } on DioException catch (e) {
      return Failure(_message(e));
    }
  }

  Future<Result<List<Game>>> fetchPopularGames({
    int? pageSize = 10,
    int page = 1,
  }) async {
    try {
      final response = await ApiClient.dio.get(
        '/games',
        queryParameters: {
          'page': page,
          'ordering': '-rating',
          'page_size': pageSize,
          'metacritic': '80,100',
          'exclude_additions': 'true',
        },
      );
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      final count = data['count'] as int;
      final games = results
          .map((item) => Game.fromJson(item as Map<String, dynamic>))
          .toList();
      return Success(data: games, count: count);
    } on DioException catch (e) {
      return Failure(_message(e));
    }
  }

  String _message(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => 'Нет соединения. Проверьте интернет.',
      DioExceptionType.badResponse =>
        'Сервер ответил ошибкой ${e.response?.statusCode}.',
      _ => 'Не удалось загрузить игры.',
    };
  }
}
