import '../models/match_event.dart';
import '../models/match_record.dart';
import '../models/player.dart';
import '../models/rule_action.dart';
import '../models/rule_set.dart';

abstract class StatsRepository {
  Future<void> initialize();

  Future<List<Player>> players();
  Future<void> savePlayer(Player player);
  Future<void> replacePlayers(List<Player> players);

  Future<List<RuleSet>> ruleSets();
  Future<RuleSet?> activeRuleSet();
  Future<List<RuleAction>> ruleActions(String ruleSetId);
  Future<void> saveRuleSet(RuleSet ruleSet);
  Future<void> saveRuleAction(RuleAction action);
  Future<void> reorderRuleActions(String ruleSetId, List<String> actionIds);

  Future<List<MatchRecord>> matches();
  Future<MatchRecord?> matchById(String id);
  Future<MatchRecord> startMatch({
    required String opponent,
    required DateTime matchDate,
    required String ruleSetId,
    required String notes,
  });
  Future<void> saveMatch(MatchRecord match);
  Future<void> nextSet(String matchId);
  Future<void> finishMatch(String matchId);

  Future<List<MatchEvent>> eventsForMatch(String matchId);
  Future<MatchEvent> recordEvent({
    required String matchId,
    required String playerId,
    required String actionId,
  });
  Future<MatchEvent?> voidLastEvent(String matchId);
  Future<MatchEvent?> voidEvent(String eventId);

  Future<Map<String, Object?>> exportBackup();
}
