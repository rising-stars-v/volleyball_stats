import '../data/models/match_event.dart';
import '../data/models/player.dart';

class PlayerScore {
  const PlayerScore({
    required this.player,
    required this.score,
    required this.eventCount,
  });

  final Player player;
  final int score;
  final int eventCount;
}

class MatchSummary {
  const MatchSummary({
    required this.playerScores,
    required this.totalsByAction,
    required this.totalsBySet,
    required this.positiveEventCount,
    required this.negativeEventCount,
    required this.overallCoachScore,
  });

  final List<PlayerScore> playerScores;
  final Map<String, int> totalsByAction;
  final Map<int, int> totalsBySet;
  final int positiveEventCount;
  final int negativeEventCount;
  final int overallCoachScore;
}

class MatchSummaryCalculator {
  MatchSummary calculate({
    required List<Player> players,
    required List<MatchEvent> events,
  }) {
    final playersById = {for (final player in players) player.id: player};
    final scoreByPlayer = <String, int>{};
    final countByPlayer = <String, int>{};
    final totalsByAction = <String, int>{};
    final totalsBySet = <int, int>{};
    var positiveCount = 0;
    var negativeCount = 0;
    var total = 0;

    for (final event in events.where((event) => !event.isVoided)) {
      scoreByPlayer.update(
        event.playerId,
        (score) => score + event.pointsSnapshot,
        ifAbsent: () => event.pointsSnapshot,
      );
      countByPlayer.update(
        event.playerId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      totalsByAction.update(
        event.actionLabelSnapshot,
        (score) => score + event.pointsSnapshot,
        ifAbsent: () => event.pointsSnapshot,
      );
      totalsBySet.update(
        event.setNumber,
        (score) => score + event.pointsSnapshot,
        ifAbsent: () => event.pointsSnapshot,
      );
      if (event.pointsSnapshot > 0) {
        positiveCount += 1;
      } else if (event.pointsSnapshot < 0) {
        negativeCount += 1;
      }
      total += event.pointsSnapshot;
    }

    final playerScores =
        scoreByPlayer.entries.map((entry) {
          final player =
              playersById[entry.key] ??
              Player(
                id: entry.key,
                jerseyNumber: 0,
                displayName: 'Unknown player',
                active: false,
                createdAt: DateTime.fromMillisecondsSinceEpoch(0),
              );
          return PlayerScore(
            player: player,
            score: entry.value,
            eventCount: countByPlayer[entry.key] ?? 0,
          );
        }).toList()..sort((a, b) {
          final scoreCompare = b.score.compareTo(a.score);
          if (scoreCompare != 0) {
            return scoreCompare;
          }
          return a.player.jerseyNumber.compareTo(b.player.jerseyNumber);
        });

    return MatchSummary(
      playerScores: playerScores,
      totalsByAction: Map.unmodifiable(totalsByAction),
      totalsBySet: Map.unmodifiable(totalsBySet),
      positiveEventCount: positiveCount,
      negativeEventCount: negativeCount,
      overallCoachScore: total,
    );
  }
}
