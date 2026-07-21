import 'package:flutter_test/flutter_test.dart';
import 'package:volleyball_stats/data/models/player.dart';
import 'package:volleyball_stats/data/repositories/in_memory_stats_repository.dart';

void main() {
  test('seeds fictional players and default rules', () async {
    final repository = InMemoryStatsRepository();
    await repository.initialize();

    final players = await repository.players();
    final ruleSet = await repository.activeRuleSet();
    final actions = await repository.ruleActions(ruleSet!.id);

    expect(
      players.map((player) => player.displayName),
      containsAll(['Alex', 'Jordan', 'Casey', 'Taylor']),
    );
    expect(
      actions.map((action) => action.label),
      containsAll([
        'Serve ace',
        'Good serve',
        'Serve error',
        'Kill',
        'Attack error',
        'Block',
      ]),
    );
  });

  test('records snapshots and voids last event without deleting it', () async {
    final repository = InMemoryStatsRepository();
    await repository.initialize();
    final player = (await repository.players()).first;
    final ruleSet = await repository.activeRuleSet();
    final action = (await repository.ruleActions(ruleSet!.id)).first;
    final match = await repository.startMatch(
      opponent: 'Central',
      matchDate: DateTime(2026),
      ruleSetId: ruleSet.id,
      notes: '',
    );

    final event = await repository.recordEvent(
      matchId: match.id,
      playerId: player.id,
      actionId: action.id,
    );
    await repository.saveRuleAction(
      action.copyWith(label: 'Changed', pointValue: 99),
    );
    final voided = await repository.voidLastEvent(match.id);
    final events = await repository.eventsForMatch(match.id);

    expect(event.actionLabelSnapshot, action.label);
    expect(event.pointsSnapshot, action.pointValue);
    expect(voided, isNotNull);
    expect(events, hasLength(1));
    expect(events.single.voidedAt, isNotNull);
  });

  test('voids a selected older event without changing other events', () async {
    final repository = InMemoryStatsRepository();
    await repository.initialize();
    final player = (await repository.players()).first;
    final ruleSet = await repository.activeRuleSet();
    final actions = await repository.ruleActions(ruleSet!.id);
    final match = await repository.startMatch(
      opponent: 'Central',
      matchDate: DateTime(2026),
      ruleSetId: ruleSet.id,
      notes: '',
    );

    final first = await repository.recordEvent(
      matchId: match.id,
      playerId: player.id,
      actionId: actions[0].id,
    );
    final second = await repository.recordEvent(
      matchId: match.id,
      playerId: player.id,
      actionId: actions[1].id,
    );

    await repository.voidEvent(first.id);
    final events = await repository.eventsForMatch(match.id);
    final firstAfterVoid = events.singleWhere((event) => event.id == first.id);
    final secondAfterVoid = events.singleWhere(
      (event) => event.id == second.id,
    );

    expect(firstAfterVoid.voidedAt, isNotNull);
    expect(secondAfterVoid.voidedAt, isNull);
  });

  test('starts match with up to five active players on court', () async {
    final repository = InMemoryStatsRepository();
    await repository.initialize();
    await repository.replacePlayers(
      List.generate(
        10,
        (index) => Player(
          id: 'player-$index',
          jerseyNumber: index + 1,
          displayName: 'Player ${index + 1}',
          active: true,
          createdAt: DateTime(2026),
        ),
      ),
    );
    final ruleSet = await repository.activeRuleSet();

    final match = await repository.startMatch(
      opponent: 'Central',
      matchDate: DateTime(2026),
      ruleSetId: ruleSet!.id,
      notes: '',
    );

    expect(match.onCourtPlayerIds, hasLength(5));
  });
}
