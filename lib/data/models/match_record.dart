enum MatchStatus { inProgress, completed }

class MatchRecord {
  const MatchRecord({
    required this.id,
    required this.opponent,
    required this.matchDate,
    required this.ruleSetId,
    required this.ruleSetVersion,
    required this.status,
    required this.currentSet,
    required this.onCourtPlayerIds,
    required this.notes,
    required this.createdAt,
    this.completedAt,
  });

  final String id;
  final String opponent;
  final DateTime matchDate;
  final String ruleSetId;
  final int ruleSetVersion;
  final MatchStatus status;
  final int currentSet;
  final List<String> onCourtPlayerIds;
  final String notes;
  final DateTime createdAt;
  final DateTime? completedAt;

  bool get isCompleted => status == MatchStatus.completed;

  MatchRecord copyWith({
    String? id,
    String? opponent,
    DateTime? matchDate,
    String? ruleSetId,
    int? ruleSetVersion,
    MatchStatus? status,
    int? currentSet,
    List<String>? onCourtPlayerIds,
    String? notes,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return MatchRecord(
      id: id ?? this.id,
      opponent: opponent ?? this.opponent,
      matchDate: matchDate ?? this.matchDate,
      ruleSetId: ruleSetId ?? this.ruleSetId,
      ruleSetVersion: ruleSetVersion ?? this.ruleSetVersion,
      status: status ?? this.status,
      currentSet: currentSet ?? this.currentSet,
      onCourtPlayerIds: onCourtPlayerIds ?? this.onCourtPlayerIds,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'opponent': opponent,
    'matchDate': matchDate.toIso8601String(),
    'ruleSetId': ruleSetId,
    'ruleSetVersion': ruleSetVersion,
    'status': status.name,
    'currentSet': currentSet,
    'onCourtPlayerIds': onCourtPlayerIds,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory MatchRecord.fromJson(Map<String, Object?> json) {
    return MatchRecord(
      id: json['id'] as String,
      opponent: json['opponent'] as String,
      matchDate: DateTime.parse(json['matchDate'] as String),
      ruleSetId: json['ruleSetId'] as String,
      ruleSetVersion: json['ruleSetVersion'] as int,
      status: MatchStatus.values.byName(json['status'] as String),
      currentSet: json['currentSet'] as int,
      onCourtPlayerIds:
          ((json['onCourtPlayerIds'] as List<Object?>?) ?? const [])
              .cast<String>(),
      notes: json['notes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }
}
