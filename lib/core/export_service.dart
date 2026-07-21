import 'dart:convert';

import '../data/models/match_event.dart';
import '../data/models/match_record.dart';
import '../data/models/player.dart';

class ExportService {
  String eventsCsv({
    required MatchRecord match,
    required List<Player> players,
    required List<MatchEvent> events,
  }) {
    final playersById = {for (final player in players) player.id: player};
    final rows = [
      [
        'match_id',
        'opponent',
        'set',
        'player_jersey',
        'player_name',
        'action',
        'category',
        'coach_score_points',
        'occurred_at',
        'voided_at',
      ],
      ...events.map((event) {
        final player = playersById[event.playerId];
        return [
          match.id,
          match.opponent,
          '${event.setNumber}',
          player == null ? '' : '${player.jerseyNumber}',
          player?.displayName ?? 'Unknown player',
          event.actionLabelSnapshot,
          event.categorySnapshot,
          '${event.pointsSnapshot}',
          event.occurredAt.toIso8601String(),
          event.voidedAt?.toIso8601String() ?? '',
        ];
      }),
    ];
    return rows.map((row) => row.map(_escape).join(',')).join('\n');
  }

  String backupJson(Map<String, Object?> backup) {
    return const JsonEncoder.withIndent('  ').convert(backup);
  }

  String _escape(String value) {
    final needsQuotes =
        value.contains(',') || value.contains('"') || value.contains('\n');
    if (!needsQuotes) {
      return value;
    }
    return '"${value.replaceAll('"', '""')}"';
  }
}
