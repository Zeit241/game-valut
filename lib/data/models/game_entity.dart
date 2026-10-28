class GameEntity {
  final int id;
  final String name;

  const GameEntity({required this.id, required this.name});

  factory GameEntity.fromJson(Map<String, dynamic> json) {
    return GameEntity(id: json['id'] as int, name: json['name'] as String);
  }
}

typedef Genre = GameEntity;
typedef Platform = GameEntity;
typedef Developer = GameEntity;
typedef Publisher = GameEntity;
