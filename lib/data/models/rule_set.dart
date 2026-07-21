class RuleSet {
  const RuleSet({
    required this.id,
    required this.name,
    required this.version,
    required this.active,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int version;
  final bool active;
  final DateTime createdAt;

  RuleSet copyWith({
    String? id,
    String? name,
    int? version,
    bool? active,
    DateTime? createdAt,
  }) {
    return RuleSet(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'version': version,
    'active': active,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RuleSet.fromJson(Map<String, Object?> json) {
    return RuleSet(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as int,
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
