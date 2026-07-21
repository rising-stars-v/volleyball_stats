class MatchEvent {
  const MatchEvent({
    required this.id,
    required this.matchId,
    required this.setNumber,
    required this.playerId,
    required this.actionId,
    required this.actionLabelSnapshot,
    required this.categorySnapshot,
    required this.pointsSnapshot,
    required this.occurredAt,
    this.voidedAt,
  });

  final String id;
  final String matchId;
  final int setNumber;
  final String playerId;
  final String actionId;
  final String actionLabelSnapshot;
  final String categorySnapshot;
  final int pointsSnapshot;
  final DateTime occurredAt;
  final DateTime? voidedAt;

  bool get isVoided => voidedAt != null;

  MatchEvent copyWith({
    String? id,
    String? matchId,
    int? setNumber,
    String? playerId,
    String? actionId,
    String? actionLabelSnapshot,
    String? categorySnapshot,
    int? pointsSnapshot,
    DateTime? occurredAt,
    DateTime? voidedAt,
  }) {
    return MatchEvent(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      setNumber: setNumber ?? this.setNumber,
      playerId: playerId ?? this.playerId,
      actionId: actionId ?? this.actionId,
      actionLabelSnapshot: actionLabelSnapshot ?? this.actionLabelSnapshot,
      categorySnapshot: categorySnapshot ?? this.categorySnapshot,
      pointsSnapshot: pointsSnapshot ?? this.pointsSnapshot,
      occurredAt: occurredAt ?? this.occurredAt,
      voidedAt: voidedAt ?? this.voidedAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'matchId': matchId,
    'setNumber': setNumber,
    'playerId': playerId,
    'actionId': actionId,
    'actionLabelSnapshot': actionLabelSnapshot,
    'categorySnapshot': categorySnapshot,
    'pointsSnapshot': pointsSnapshot,
    'occurredAt': occurredAt.toIso8601String(),
    'voidedAt': voidedAt?.toIso8601String(),
  };

  factory MatchEvent.fromJson(Map<String, Object?> json) {
    return MatchEvent(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      setNumber: json['setNumber'] as int,
      playerId: json['playerId'] as String,
      actionId: json['actionId'] as String,
      actionLabelSnapshot: json['actionLabelSnapshot'] as String,
      categorySnapshot: json['categorySnapshot'] as String,
      pointsSnapshot: json['pointsSnapshot'] as int,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      voidedAt: json['voidedAt'] == null
          ? null
          : DateTime.parse(json['voidedAt'] as String),
    );
  }
}
