import 'package:flutter_test/flutter_test.dart';
import 'package:volleyball_stats/core/match_summary.dart';
import 'package:volleyball_stats/data/models/match_event.dart';
import 'package:volleyball_stats/data/models/player.dart';

void main() {
  test('calculates coach score from non-voided event snapshots', () {
    final player = Player(
      id: 'p1',
      jerseyNumber: 3,
      displayName: 'Alex',
      active: true,
      createdAt: DateTime(2026),
    );
    final now = DateTime(2026);
    final events = [
      MatchEvent(
        id: 'e1',
        matchId: 'm1',
        setNumber: 1,
        playerId: 'p1',
        actionId: 'a1',
        actionLabelSnapshot: 'Kill',
        categorySnapshot: 'Attack',
        pointsSnapshot: 2,
        occurredAt: now,
      ),
      MatchEvent(
        id: 'e2',
        matchId: 'm1',
        setNumber: 1,
        playerId: 'p1',
        actionId: 'a2',
        actionLabelSnapshot: 'Attack error',
        categorySnapshot: 'Attack',
        pointsSnapshot: -1,
        occurredAt: now,
        voidedAt: now,
      ),
    ];

    final summary = MatchSummaryCalculator().calculate(
      players: [player],
      events: events,
    );

    expect(summary.overallCoachScore, 2);
    expect(summary.positiveEventCount, 1);
    expect(summary.negativeEventCount, 0);
    expect(summary.playerScores.single.score, 2);
  });
}
