class RuleAction {
  const RuleAction({
    required this.id,
    required this.ruleSetId,
    required this.category,
    required this.label,
    required this.pointValue,
    required this.color,
    required this.sortOrder,
    required this.active,
  });

  final String id;
  final String ruleSetId;
  final String category;
  final String label;
  final int pointValue;
  final int color;
  final int sortOrder;
  final bool active;

  RuleAction copyWith({
    String? id,
    String? ruleSetId,
    String? category,
    String? label,
    int? pointValue,
    int? color,
    int? sortOrder,
    bool? active,
  }) {
    return RuleAction(
      id: id ?? this.id,
      ruleSetId: ruleSetId ?? this.ruleSetId,
      category: category ?? this.category,
      label: label ?? this.label,
      pointValue: pointValue ?? this.pointValue,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      active: active ?? this.active,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'ruleSetId': ruleSetId,
    'category': category,
    'label': label,
    'pointValue': pointValue,
    'color': color,
    'sortOrder': sortOrder,
    'active': active,
  };

  factory RuleAction.fromJson(Map<String, Object?> json) {
    return RuleAction(
      id: json['id'] as String,
      ruleSetId: json['ruleSetId'] as String,
      category: json['category'] as String,
      label: json['label'] as String,
      pointValue: json['pointValue'] as int,
      color: json['color'] as int,
      sortOrder: json['sortOrder'] as int,
      active: json['active'] as bool,
    );
  }
}
