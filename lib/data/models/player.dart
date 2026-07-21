class Player {
  const Player({
    required this.id,
    required this.jerseyNumber,
    required this.displayName,
    required this.active,
    required this.createdAt,
  });

  final String id;
  final int jerseyNumber;
  final String displayName;
  final bool active;
  final DateTime createdAt;

  Player copyWith({
    String? id,
    int? jerseyNumber,
    String? displayName,
    bool? active,
    DateTime? createdAt,
  }) {
    return Player(
      id: id ?? this.id,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      displayName: displayName ?? this.displayName,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'jerseyNumber': jerseyNumber,
    'displayName': displayName,
    'active': active,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Player.fromJson(Map<String, Object?> json) {
    return Player(
      id: json['id'] as String,
      jerseyNumber: json['jerseyNumber'] as int,
      displayName: json['displayName'] as String,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
