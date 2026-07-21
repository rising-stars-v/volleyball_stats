import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/match_event.dart';
import '../models/match_record.dart';
import '../models/player.dart';
import '../models/rule_action.dart';
import '../models/rule_set.dart';
import 'stats_repository.dart';

class InMemoryStatsRepository extends ChangeNotifier
    implements StatsRepository {
  InMemoryStatsRepository({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  final Map<String, Player> _players = {};
  final Map<String, RuleSet> _ruleSets = {};
  final Map<String, RuleAction> _actions = {};
  final Map<String, MatchRecord> _matches = {};
  final Map<String, MatchEvent> _events = {};

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    if (_players.isEmpty && _ruleSets.isEmpty) {
      seedDefaults();
      await afterWrite();
    }
  }

  @protected
  void loadSnapshot(Map<String, Object?> snapshot) {
    _players
      ..clear()
      ..addEntries(
        ((snapshot['players'] as List<Object?>?) ?? const []).map((item) {
          final player = Player.fromJson(
            Map<String, Object?>.from(item as Map),
          );
          return MapEntry(player.id, player);
        }),
      );
    _ruleSets
      ..clear()
      ..addEntries(
        ((snapshot['ruleSets'] as List<Object?>?) ?? const []).map((item) {
          final ruleSet = RuleSet.fromJson(
            Map<String, Object?>.from(item as Map),
          );
          return MapEntry(ruleSet.id, ruleSet);
        }),
      );
    _actions
      ..clear()
      ..addEntries(
        ((snapshot['ruleActions'] as List<Object?>?) ?? const []).map((item) {
          final action = RuleAction.fromJson(
            Map<String, Object?>.from(item as Map),
          );
          return MapEntry(action.id, action);
        }),
      );
    _matches
      ..clear()
      ..addEntries(
        ((snapshot['matches'] as List<Object?>?) ?? const []).map((item) {
          final match = MatchRecord.fromJson(
            Map<String, Object?>.from(item as Map),
          );
          return MapEntry(match.id, match);
        }),
      );
    _events
      ..clear()
      ..addEntries(
        ((snapshot['events'] as List<Object?>?) ?? const []).map((item) {
          final event = MatchEvent.fromJson(
            Map<String, Object?>.from(item as Map),
          );
          return MapEntry(event.id, event);
        }),
      );
  }

  @protected
  Future<void> afterWrite() async {}

  @override
  Future<Map<String, Object?>> exportBackup() async {
    return {
      'exportedAt': DateTime.now().toIso8601String(),
      'players': _players.values.map((player) => player.toJson()).toList(),
      'ruleSets': _ruleSets.values.map((ruleSet) => ruleSet.toJson()).toList(),
      'ruleActions': _actions.values.map((action) => action.toJson()).toList(),
      'matches': _matches.values.map((match) => match.toJson()).toList(),
      'events': _events.values.map((event) => event.toJson()).toList(),
    };
  }

  @override
  Future<List<Player>> players() async {
    final list = _players.values.toList()
      ..sort((a, b) => a.jerseyNumber.compareTo(b.jerseyNumber));
    return list;
  }

  @override
  Future<void> savePlayer(Player player) async {
    _validatePlayer(player);
    _players[player.id] = player;
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<void> replacePlayers(List<Player> players) async {
    final activeNumbers = <int>{};
    for (final player in players) {
      if (player.active && !activeNumbers.add(player.jerseyNumber)) {
        throw ArgumentError('Duplicate active jersey #${player.jerseyNumber}.');
      }
    }
    _players
      ..clear()
      ..addEntries(players.map((player) => MapEntry(player.id, player)));
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<List<RuleSet>> ruleSets() async {
    final list = _ruleSets.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  @override
  Future<RuleSet?> activeRuleSet() async {
    final active = _ruleSets.values.where((ruleSet) => ruleSet.active).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return active.isEmpty ? null : active.first;
  }

  @override
  Future<List<RuleAction>> ruleActions(String ruleSetId) async {
    final list =
        _actions.values
            .where((action) => action.ruleSetId == ruleSetId)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  @override
  Future<void> saveRuleSet(RuleSet ruleSet) async {
    _ruleSets[ruleSet.id] = ruleSet;
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<void> saveRuleAction(RuleAction action) async {
    if (!_ruleSets.containsKey(action.ruleSetId)) {
      throw ArgumentError('Unknown rule set ${action.ruleSetId}.');
    }
    _actions[action.id] = action;
    _bumpRuleSetVersion(action.ruleSetId);
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<void> reorderRuleActions(
    String ruleSetId,
    List<String> actionIds,
  ) async {
    for (var index = 0; index < actionIds.length; index += 1) {
      final action = _actions[actionIds[index]];
      if (action != null && action.ruleSetId == ruleSetId) {
        _actions[action.id] = action.copyWith(sortOrder: index);
      }
    }
    _bumpRuleSetVersion(ruleSetId);
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<List<MatchRecord>> matches() async {
    final list = _matches.values.toList()
      ..sort((a, b) => b.matchDate.compareTo(a.matchDate));
    return list;
  }

  @override
  Future<MatchRecord?> matchById(String id) async => _matches[id];

  @override
  Future<MatchRecord> startMatch({
    required String opponent,
    required DateTime matchDate,
    required String ruleSetId,
    required String notes,
  }) async {
    final ruleSet = _ruleSets[ruleSetId];
    if (ruleSet == null) {
      throw ArgumentError('Select a rule set before starting a match.');
    }
    final now = DateTime.now();
    final onCourtPlayerIds =
        (_players.values.where((player) => player.active).toList()
              ..sort((a, b) => a.jerseyNumber.compareTo(b.jerseyNumber)))
            .take(5)
            .map((player) => player.id)
            .toList();
    final match = MatchRecord(
      id: _uuid.v4(),
      opponent: opponent.trim().isEmpty ? 'Opponent' : opponent.trim(),
      matchDate: matchDate,
      ruleSetId: ruleSetId,
      ruleSetVersion: ruleSet.version,
      status: MatchStatus.inProgress,
      currentSet: 1,
      onCourtPlayerIds: onCourtPlayerIds,
      notes: notes.trim(),
      createdAt: now,
    );
    _matches[match.id] = match;
    notifyListeners();
    await afterWrite();
    return match;
  }

  @override
  Future<void> saveMatch(MatchRecord match) async {
    _matches[match.id] = match;
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<void> nextSet(String matchId) async {
    final match = _requireMatch(matchId);
    if (match.isCompleted) {
      throw StateError('Completed matches cannot move to another set.');
    }
    _matches[match.id] = match.copyWith(currentSet: match.currentSet + 1);
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<void> finishMatch(String matchId) async {
    final match = _requireMatch(matchId);
    _matches[match.id] = match.copyWith(
      status: MatchStatus.completed,
      completedAt: DateTime.now(),
    );
    notifyListeners();
    await afterWrite();
  }

  @override
  Future<List<MatchEvent>> eventsForMatch(String matchId) async {
    final list =
        _events.values.where((event) => event.matchId == matchId).toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return list;
  }

  @override
  Future<MatchEvent> recordEvent({
    required String matchId,
    required String playerId,
    required String actionId,
  }) async {
    final match = _requireMatch(matchId);
    if (match.isCompleted) {
      throw StateError('Completed matches cannot receive events.');
    }
    final player = _players[playerId];
    if (player == null || !player.active) {
      throw ArgumentError('Select an active player.');
    }
    final action = _actions[actionId];
    if (action == null || !action.active) {
      throw ArgumentError('Select an active action.');
    }
    final event = MatchEvent(
      id: _uuid.v4(),
      matchId: matchId,
      setNumber: match.currentSet,
      playerId: playerId,
      actionId: actionId,
      actionLabelSnapshot: action.label,
      categorySnapshot: action.category,
      pointsSnapshot: action.pointValue,
      occurredAt: DateTime.now(),
    );
    _events[event.id] = event;
    notifyListeners();
    await afterWrite();
    return event;
  }

  @override
  Future<MatchEvent?> voidLastEvent(String matchId) async {
    final candidates =
        _events.values
            .where((event) => event.matchId == matchId && !event.isVoided)
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (candidates.isEmpty) {
      return null;
    }
    final event = candidates.first.copyWith(voidedAt: DateTime.now());
    _events[event.id] = event;
    notifyListeners();
    await afterWrite();
    return event;
  }

  @override
  Future<MatchEvent?> voidEvent(String eventId) async {
    final existing = _events[eventId];
    if (existing == null || existing.isVoided) {
      return existing;
    }
    final event = existing.copyWith(voidedAt: DateTime.now());
    _events[event.id] = event;
    notifyListeners();
    await afterWrite();
    return event;
  }

  void seedDefaults() {
    final now = DateTime.now();
    for (final seed in const [
      (3, 'Alex'),
      (7, 'Jordan'),
      (11, 'Casey'),
      (18, 'Taylor'),
    ]) {
      final player = Player(
        id: _uuid.v4(),
        jerseyNumber: seed.$1,
        displayName: seed.$2,
        active: true,
        createdAt: now,
      );
      _players[player.id] = player;
    }

    final ruleSet = RuleSet(
      id: _uuid.v4(),
      name: 'Default Coach Score',
      version: 1,
      active: true,
      createdAt: now,
    );
    _ruleSets[ruleSet.id] = ruleSet;

    final defaults = [
      ('Serve', 'Serve ace', 2, 0xFF2E7D32),
      ('Serve', 'Good serve', 1, 0xFF43A047),
      ('Serve', 'Serve error', -1, 0xFFC62828),
      ('Attack', 'Kill', 2, 0xFF1565C0),
      ('Attack', 'Good attack', 1, 0xFF1976D2),
      ('Attack', 'Attack error', -1, 0xFFAD1457),
      ('Block', 'Block', 2, 0xFF6A1B9A),
      ('Block', 'Block touch', 1, 0xFF8E24AA),
      ('Error', 'Ball handling error', -1, 0xFFEF6C00),
    ];
    for (var index = 0; index < defaults.length; index += 1) {
      final item = defaults[index];
      final action = RuleAction(
        id: _uuid.v4(),
        ruleSetId: ruleSet.id,
        category: item.$1,
        label: item.$2,
        pointValue: item.$3,
        color: item.$4,
        sortOrder: index,
        active: true,
      );
      _actions[action.id] = action;
    }
  }

  void _validatePlayer(Player player) {
    if (player.jerseyNumber < 0 || player.jerseyNumber > 999) {
      throw ArgumentError('Jersey number must be between 0 and 999.');
    }
    if (player.displayName.trim().isEmpty) {
      throw ArgumentError('Display name is required.');
    }
    if (!player.active) {
      return;
    }
    final duplicate = _players.values.any(
      (existing) =>
          existing.id != player.id &&
          existing.active &&
          existing.jerseyNumber == player.jerseyNumber,
    );
    if (duplicate) {
      throw ArgumentError(
        'Active jersey #${player.jerseyNumber} already exists.',
      );
    }
  }

  MatchRecord _requireMatch(String id) {
    final match = _matches[id];
    if (match == null) {
      throw ArgumentError('Unknown match $id.');
    }
    return match;
  }

  void _bumpRuleSetVersion(String ruleSetId) {
    final ruleSet = _ruleSets[ruleSetId];
    if (ruleSet != null) {
      _ruleSets[ruleSet.id] = ruleSet.copyWith(version: ruleSet.version + 1);
    }
  }
}
