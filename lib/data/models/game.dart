import '../../ui/core/database/app_database.dart';
import 'game_entity.dart';

class Game {
  final int id;
  final String name;
  final String backgroundImage;
  final String released;
  final double rating;
  final List<Platform> platforms;
  final List<Genre> genres;
  final List<Developer> developers;

  Game({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.released,
    required this.rating,
    required this.platforms,
    required this.genres,
    required this.developers,
  });

  Game.placeholder()
    : id = 0,
      name = "",
      backgroundImage = '',
      released = '',
      rating = 10.0,
      platforms = [],
      developers = [],
      genres = [];

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
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
      genres: ((json['genres'] as List?) ?? const [])
          .map((item) => Genre.fromJson(item as Map<String, dynamic>))
          .toList(),
      developers: ((json['developers'] as List?) ?? const [])
          .map((item) => GameEntity.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }


  factory Game.fromDb(LibraryGame game) {
    final released = game.released;
    final releasedText = released == null
        ? ''
        : '${released.year.toString().padLeft(4, '0')}-'
              '${released.month.toString().padLeft(2, '0')}-'
              '${released.day.toString().padLeft(2, '0')}';

    return Game(
      id: game.id,
      name: game.name,
      backgroundImage: '',
      released: releasedText,
      rating: game.rating.toDouble(),
      platforms: const [],
      genres: const [],
      developers: game.developer.isEmpty
          ? const []
          : [GameEntity(id: 0, name: game.developer)],
    );
  }

  int? parseReleasedYear() {
    return DateTime.tryParse(released)?.year;
  }

  String croppedImage({int width = 600, int height = 400}) {
    return backgroundImage.replaceFirst(
      '/media/games/',
      '/media/crop/$width/$height/games/',
    );
  }

  String getGameGenres({int limit = 2}) {
    if (genres.isEmpty) return '';

    return genres.take(limit).map((e) => e.name).join(', ');
  }

  String getGamePlatforms({int limit = 2}) {
    if (platforms.isEmpty) return '';

    return platforms.take(limit).map((e) => e.name).join(', ');
  }
}
