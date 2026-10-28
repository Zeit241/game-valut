import 'package:game_shelf/data/models/game.dart';
import 'package:game_shelf/data/models/game_entity.dart';

Map<String, String> shortPlatformNames = {
  'PlayStation': 'PS',
  'Apple Macintosh': 'MAC',
};

class DetailedGame extends Game {
  final String description;
  final int ratingsCount;
  final List<Platform> parentPlatforms;
  final List<Developer> publisher;
  final List<GameEntity> tags;
  final List<Map<String, dynamic>>? screenshots;
  final int playtime;

  new({
    required super.id,
    required super.name,
    required super.backgroundImage,
    required super.released,
    required super.rating,
    required super.platforms,
    required super.genres,
    required super.developers,
    required this.description,
    required this.ratingsCount,
    required this.parentPlatforms,
    required this.publisher,
    required this.playtime,
    required this.tags,
    this.screenshots,
  });

  factory DetailedGame.fromJson(
    Map<String, dynamic> json, {
    List<Map<String, dynamic>>? screenshots,
  }) {
    return DetailedGame(
      id: json['id'] as int,
      name: json['name'] as String,
      backgroundImage: json['background_image'] as String? ?? '',
      released: json['released'] as String? ?? '',
      rating: ((json['metacritic'] as num?)?.toDouble() ?? 0) / 10,
      platforms: ((json['platforms'] as List?) ?? const [])
          .map(
            (item) => Platform.fromJson(
              (item as Map<String, dynamic>)['platform']
                  as Map<String, dynamic>,
            ),
          )
          .toList(),
      parentPlatforms: ((json['parent_platforms'] as List?) ?? const [])
          .map(
            (item) => Platform.fromJson(
              (item as Map<String, dynamic>)['platform']
                  as Map<String, dynamic>,
            ),
          )
          .toList(),
      genres: [
        ...((json['genres'] as List?) ?? const [])
            .map((item) => Genre.fromJson(item as Map<String, dynamic>))
            .toList(),
      ],
      developers: ((json['developers'] as List?) ?? const [])
          .map((item) => GameEntity.fromJson(item as Map<String, dynamic>))
          .toList(),
      description: json['description_raw'] as String,
      ratingsCount: json['ratings_count'] as int,
      publisher: ((json['developers'] as List?) ?? const [])
          .map((item) => GameEntity.fromJson(item as Map<String, dynamic>))
          .toList(),
      tags: ((json['tags'] as List?) ?? const [])
          .map((item) => GameEntity.fromJson(item as Map<String, dynamic>))
          .toList(),
      screenshots: screenshots,
      playtime: json['playtime'] as int,
    );
  }

  String getGameParentPlatforms({int limit = 2}) {
    if (parentPlatforms.isEmpty) return '';

    return parentPlatforms.take(limit).map((e) => e.name).join(', ');
  }

  String getShortGameParentPlatforms({int limit = 2}) {
    if (parentPlatforms.isEmpty) return '';

    String names = parentPlatforms.take(limit).map((e) => e.name).join(', ');

    for (final entry in shortPlatformNames.entries) {
      names = names.replaceAll(entry.key, entry.value);
    }
    return names;
  }
}
