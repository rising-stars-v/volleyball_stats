import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../core/export_service.dart';
import '../core/match_summary.dart';
import '../core/roster_csv.dart';
import '../data/models/match_event.dart';
import '../data/models/match_record.dart';
import '../data/models/player.dart';
import '../data/models/rule_action.dart';
import '../data/models/rule_set.dart';
import '../data/repositories/stats_repository.dart';

class AppState extends ChangeNotifier {
  AppState(this.repository);

  final StatsRepository repository;
  final _uuid = const Uuid();
  final _summaryCalculator = MatchSummaryCalculator();
  final _exportService = ExportService();

  bool loading = true;
  String? errorMessage;
  List<Player> players = [];
  List<RuleSet> ruleSets = [];
  List<RuleAction> actions = [];
  List<MatchRecord> matches = [];
  MatchRecord? currentMatch;
  List<MatchEvent> currentEvents = [];
  String? selectedPlayerId;

  DateTime? _lastRecordedAt;
  String? _lastRecordedKey;

  List<Player> get activePlayers =>
      players.where((player) => player.active).toList();
  List<String> get onCourtPlayerIds {
    final explicit = currentMatch?.onCourtPlayerIds ?? const [];
    final activeIds = activePlayers.map((player) => player.id).toSet();
    final filtered = explicit.where(activeIds.contains).toList();
    if (filtered.isNotEmpty) {
      return filtered.take(5).toList();
    }
    return activePlayers.take(5).map((player) => player.id).toList();
  }

  List<Player> get onCourtPlayers {
    final ids = onCourtPlayerIds;
    final playersById = {for (final player in activePlayers) player.id: player};
    return ids.map((id) => playersById[id]).whereType<Player>().toList();
  }

  List<Player> get benchPlayers {
    final courtIds = onCourtPlayerIds.toSet();
    return activePlayers
        .where((player) => !courtIds.contains(player.id))
        .toList();
  }

  List<RuleAction> get activeActions =>
      actions.where((action) => action.active).toList();
  RuleSet? get activeRuleSet => ruleSets.where((set) => set.active).firstOrNull;
  List<MatchRecord> get unfinishedMatches =>
      matches.where((match) => match.status == MatchStatus.inProgress).toList();
  MatchSummary get currentSummary =>
      _summaryCalculator.calculate(players: players, events: currentEvents);

  Future<void> initialize() async {
    loading = true;
    notifyListeners();
    await _guard(() async {
      await repository.initialize();
      await refresh();
    });
    loading = false;
    notifyListeners();
  }

  Future<void> refresh({String? matchId}) async {
    players = await repository.players();
    ruleSets = await repository.ruleSets();
    final ruleSet = activeRuleSet ?? (ruleSets.isEmpty ? null : ruleSets.first);
    actions = ruleSet == null ? [] : await repository.ruleActions(ruleSet.id);
    matches = await repository.matches();
    final activeId =
        matchId ?? currentMatch?.id ?? unfinishedMatches.firstOrNull?.id;
    currentMatch = activeId == null
        ? null
        : await repository.matchById(activeId);
    currentEvents = currentMatch == null
        ? []
        : await repository.eventsForMatch(currentMatch!.id);
    selectedPlayerId ??= activePlayers.firstOrNull?.id;
    if (selectedPlayerId != null &&
        !activePlayers.any((player) => player.id == selectedPlayerId)) {
      selectedPlayerId = activePlayers.firstOrNull?.id;
    }
    notifyListeners();
  }

  Future<void> savePlayer({
    String? id,
    required int jerseyNumber,
    required String displayName,
    required bool active,
  }) async {
    await _guard(() async {
      await repository.savePlayer(
        Player(
          id: id ?? _uuid.v4(),
          jerseyNumber: jerseyNumber,
          displayName: displayName.trim(),
          active: active,
          createdAt:
              players
                  .where((player) => player.id == id)
                  .firstOrNull
                  ?.createdAt ??
              DateTime.now(),
        ),
      );
      await refresh();
    });
  }

  RosterCsvResult validateRosterCsv(String csvText) {
    return RosterCsvParser().parse(csvText);
  }

  Future<void> importRosterCsv(String csvText) async {
    final result = validateRosterCsv(csvText);
    if (!result.isValid) {
      throw ArgumentError(result.errors.join('\n'));
    }
    await _guard(() async {
      await repository.replacePlayers(result.players);
      await refresh();
    });
  }

  Future<void> saveAction({
    String? id,
    required String category,
    required String label,
    required int pointValue,
    required int color,
    required bool active,
  }) async {
    final ruleSet = activeRuleSet;
    if (ruleSet == null) {
      throw StateError('No active rule set found.');
    }
    final existing = actions.where((action) => action.id == id).firstOrNull;
    await _guard(() async {
      await repository.saveRuleAction(
        RuleAction(
          id: id ?? _uuid.v4(),
          ruleSetId: ruleSet.id,
          category: category.trim(),
          label: label.trim(),
          pointValue: pointValue,
          color: color,
          sortOrder: existing?.sortOrder ?? actions.length,
          active: active,
        ),
      );
      await refresh();
    });
  }

  Future<void> reorderAction(int oldIndex, int newIndex) async {
    final reordered = [...actions];
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);
    await _guard(() async {
      await repository.reorderRuleActions(
        item.ruleSetId,
        reordered.map((action) => action.id).toList(),
      );
      await refresh();
    });
  }

  Future<void> startMatch(String opponent, String notes) async {
    final ruleSet = activeRuleSet;
    if (ruleSet == null) {
      throw StateError('Create a rule set before starting a match.');
    }
    await _guard(() async {
      final match = await repository.startMatch(
        opponent: opponent,
        matchDate: DateTime.now(),
        ruleSetId: ruleSet.id,
        notes: notes,
      );
      await refresh(matchId: match.id);
    });
  }

  Future<void> resumeMatch(String matchId) async {
    await refresh(matchId: matchId);
  }

  void selectPlayer(String playerId) {
    selectedPlayerId = playerId;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<void> setPlayerOnCourt(String playerId, bool onCourt) async {
    final match = currentMatch;
    if (match == null) {
      return;
    }
    final ids = [...onCourtPlayerIds];
    if (onCourt) {
      if (ids.contains(playerId)) {
        return;
      }
      if (ids.length >= 5) {
        errorMessage = 'Move one player to bench before adding another.';
        notifyListeners();
        return;
      }
      ids.add(playerId);
    } else {
      ids.remove(playerId);
      if (selectedPlayerId == playerId) {
        selectedPlayerId = ids.firstOrNull ?? benchPlayers.firstOrNull?.id;
      }
    }
    await _guard(() async {
      await repository.saveMatch(match.copyWith(onCourtPlayerIds: ids));
      await refresh(matchId: match.id);
    });
  }

  Future<void> recordEvent(String actionId) async {
    final match = currentMatch;
    final playerId = selectedPlayerId;
    if (match == null || playerId == null) {
      return;
    }
    final key = '$playerId:$actionId';
    final now = DateTime.now();
    if (_lastRecordedKey == key &&
        _lastRecordedAt != null &&
        now.difference(_lastRecordedAt!) < const Duration(milliseconds: 600)) {
      return;
    }
    _lastRecordedKey = key;
    _lastRecordedAt = now;
    await _guard(() async {
      await repository.recordEvent(
        matchId: match.id,
        playerId: playerId,
        actionId: actionId,
      );
      await refresh(matchId: match.id);
    });
  }

  Future<void> nextSet() async {
    final match = currentMatch;
    if (match == null) {
      return;
    }
    await _guard(() async {
      await repository.nextSet(match.id);
      await refresh(matchId: match.id);
    });
  }

  Future<void> undoLastEvent() async {
    final match = currentMatch;
    if (match == null) {
      return;
    }
    await _guard(() async {
      await repository.voidLastEvent(match.id);
      await refresh(matchId: match.id);
    });
  }

  Future<void> voidEvent(String eventId) async {
    final match = currentMatch;
    if (match == null) {
      return;
    }
    await _guard(() async {
      await repository.voidEvent(eventId);
      await refresh(matchId: match.id);
    });
  }

  Future<void> finishCurrentMatch() async {
    final match = currentMatch;
    if (match == null) {
      return;
    }
    await _guard(() async {
      await repository.finishMatch(match.id);
      await refresh(matchId: match.id);
    });
  }

  String currentMatchCsv() {
    final match = currentMatch;
    if (match == null) {
      return '';
    }
    return _exportService.eventsCsv(
      match: match,
      players: players,
      events: currentEvents,
    );
  }

  Future<String> backupJson() async {
    return _exportService.backupJson(await repository.exportBackup());
  }

  Future<void> shareCurrentMatch() async {
    final csv = currentMatchCsv();
    if (csv.isEmpty) {
      return;
    }
    await SharePlus.instance.share(
      ShareParams(text: csv, subject: 'Volleyball Coach Score export'),
    );
  }

  Future<void> shareBackup() async {
    await SharePlus.instance.share(
      ShareParams(
        text: const JsonEncoder.withIndent(
          '  ',
        ).convert(await repository.exportBackup()),
        subject: 'Volleyball Coach Score backup',
      ),
    );
  }

  Future<void> _guard(Future<void> Function() run) async {
    try {
      errorMessage = null;
      await run();
    } catch (error) {
      errorMessage = error is ArgumentError ? error.message : error.toString();
      notifyListeners();
    }
  }
}
