class Level {
  final int levelId;
  final List<int> order;
  final int background;
  // final int difficulty;
  final List<Map<String,dynamic>> obstacles;
  final List<Map<String,dynamic>> boundaries;

  Level({
    required this.levelId,
    required this.order,
    required this.background,
    // required this.difficulty,
    required this.obstacles,
    required this.boundaries,
  });

  /// copy the level state
  Level copy() {
    return Level(
      levelId: levelId,
      order: List<int>.from(order),
      background: background,
      // difficulty: difficulty,
      obstacles: List<Map<String,dynamic>>.from(obstacles),
      boundaries: List<Map<String,dynamic>>.from(boundaries),
    );
  }

  // create a level state from JSON
  factory Level.fromJson(Map<String,dynamic> json) {
    return Level(
      levelId: json["levelId"] is int ? json["levelId"] : int.parse(json["levelId"]),
      order: List<int>.from(json["order"]),
      background: json["background"],
      // difficulty: json["difficulty"] is int ? json["difficulty"]: int.parse(json["difficulty"]),
      obstacles: List<Map<String,dynamic>>.from(json["obstacles"]),
      boundaries: List<Map<String,dynamic>>.from(json["boundaries"]),      
    );
  }

  // convert the level state to JSON
  Map<String,dynamic> toJson() {
    return {
      'levelId' : levelId,
      'order' : order,
      'background' : background,
      // 'difficulty' : difficulty,
      'obstacles' : obstacles,
      'boundaries' : boundaries,
    };
  }
}

