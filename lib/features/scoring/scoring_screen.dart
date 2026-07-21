import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/app_state.dart';
import '../../data/models/match_record.dart';
import '../../data/models/player.dart';

class ScoringScreen extends StatelessWidget {
  const ScoringScreen({
    super.key,
    required this.appState,
    required this.onOpenMatches,
    required this.onOpenReports,
  });

  final AppState appState;
  final VoidCallback onOpenMatches;
  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context) {
    final match = appState.currentMatch;
    if (match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Scoring')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.scoreboard_outlined, size: 56),
                const SizedBox(height: 16),
                Text(
                  'No active match',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start or resume a match before using live scoring.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onOpenMatches,
                  icon: const Icon(Icons.sports_volleyball),
                  label: const Text('Go to Matches'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final selectedPlayer = appState.players
        .where((player) => player.id == appState.selectedPlayerId)
        .firstOrNull;
    final selectedScore = selectedPlayer == null
        ? 0
        : appState.currentEvents
              .where(
                (event) =>
                    !event.isVoided && event.playerId == selectedPlayer.id,
              )
              .fold<int>(0, (sum, event) => sum + event.pointsSnapshot);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Matches',
          onPressed: onOpenMatches,
          icon: const Icon(Icons.sports_volleyball),
        ),
        title: Text('${match.opponent} • Set ${match.currentSet}'),
        actions: [
          IconButton(
            tooltip: 'Summary',
            onPressed: onOpenReports,
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 900
          ? _CompactScoringControlBar(appState: appState)
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final statusBar = _StatusBar(
                match: match,
                selectedPlayer: selectedPlayer,
                selectedScore: selectedScore,
              );
              final playerPanel = _PlayerGrid(appState: appState);
              final actionPanel = _ActionGrid(appState: appState);
              final eventsPanel = _RecentEvents(appState: appState);
              final controls = _ScoringControls(
                appState: appState,
                onOpenReports: onOpenReports,
              );

              if (!wide) {
                return _CompactScoringLayout(
                  appState: appState,
                  statusBar: statusBar,
                );
              }

              return Column(
                children: [
                  statusBar,
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: playerPanel),
                        const SizedBox(width: 16),
                        Expanded(flex: 4, child: actionPanel),
                        const SizedBox(width: 16),
                        Expanded(flex: 3, child: eventsPanel),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  controls,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CompactScoringLayout extends StatelessWidget {
  const _CompactScoringLayout({
    required this.appState,
    required this.statusBar,
  });

  final AppState appState;
  final Widget statusBar;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        statusBar,
        const SizedBox(height: 12),
        _CompactPlayerGrid(appState: appState),
        const SizedBox(height: 14),
        _CompactActionGrid(appState: appState),
      ],
    );
  }
}

class _CompactPlayerGrid extends StatelessWidget {
  const _CompactPlayerGrid({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth - 20) / 3;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Players',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showLineupSheet(context, appState),
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: Text('Bench (${appState.benchPlayers.length})'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: appState.onCourtPlayers.map((player) {
                final selected = player.id == appState.selectedPlayerId;
                return SizedBox(
                  width: buttonWidth,
                  height: 58,
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      backgroundColor: selected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                    ),
                    onPressed: () => appState.selectPlayer(player.id),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '#${player.jerseyNumber}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          player.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _CompactActionGrid extends StatelessWidget {
  const _CompactActionGrid({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth - 16) / 3;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: appState.activeActions.map((action) {
                final points = action.pointValue > 0
                    ? '+${action.pointValue}'
                    : '${action.pointValue}';
                return SizedBox(
                  width: buttonWidth,
                  height: 64,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      backgroundColor: Color(action.color),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => appState.recordEvent(action.id),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          action.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        Text(
                          points,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _CompactScoringControlBar extends StatelessWidget {
  const _CompactScoringControlBar({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final completed = appState.currentMatch?.status == MatchStatus.completed;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, bottomInset + 12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: completed
                    ? null
                    : () => _confirm(
                        context,
                        'Move to next set?',
                        appState.nextSet,
                      ),
                icon: const Icon(Icons.skip_next, size: 18),
                label: const FittedBox(child: Text('Next')),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: completed
                    ? null
                    : () => _confirm(
                        context,
                        'Void the last event?',
                        appState.undoLastEvent,
                      ),
                icon: const Icon(Icons.undo, size: 18),
                label: const FittedBox(child: Text('Undo')),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: () => _showRecentEvents(context),
                icon: const Icon(Icons.history, size: 18),
                label: const FittedBox(child: Text('Recent')),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                onPressed: completed
                    ? null
                    : () => _confirm(
                        context,
                        'Finish this match?',
                        appState.finishCurrentMatch,
                      ),
                icon: const Icon(Icons.flag, size: 18),
                label: const FittedBox(child: Text('Finish')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    String message,
    Future<void> Function() action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await action();
    }
  }

  Future<void> _showRecentEvents(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            height: 420,
            child: _RecentEvents(appState: appState),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.match,
    required this.selectedPlayer,
    required this.selectedScore,
  });

  final MatchRecord match;
  final Player? selectedPlayer;
  final int selectedScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              'Set ${match.currentSet}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                selectedPlayer == null
                    ? 'No player selected'
                    : 'Selected #${selectedPlayer!.jerseyNumber} ${selectedPlayer!.displayName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              'Coach Score ${selectedScore >= 0 ? '+' : ''}$selectedScore',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerGrid extends StatelessWidget {
  const _PlayerGrid({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Players', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisExtent: 84,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: appState.onCourtPlayers.length,
            itemBuilder: (context, index) {
              final player = appState.onCourtPlayers[index];
              final selected = player.id == appState.selectedPlayerId;
              return FilledButton.tonal(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(96, 64),
                  backgroundColor: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                ),
                onPressed: () => appState.selectPlayer(player.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '#${player.jerseyNumber}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(player.displayName, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _showLineupSheet(context, appState),
            icon: const Icon(Icons.swap_horiz),
            label: Text('Bench / Lineup (${appState.benchPlayers.length})'),
          ),
        ),
      ],
    );
  }
}

Future<void> _showLineupSheet(BuildContext context, AppState appState) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: _LineupSheet(appState: appState),
      ),
    ),
  );
}

class _LineupSheet extends StatelessWidget {
  const _LineupSheet({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return ListView(
          shrinkWrap: true,
          children: [
            Text('Lineup', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Keep up to 5 players on court. Bench players are available for substitutions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text('On Court', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...appState.onCourtPlayers.map(
              (player) => ListTile(
                leading: CircleAvatar(child: Text('#${player.jerseyNumber}')),
                title: Text(player.displayName),
                subtitle: const Text('On court'),
                trailing: TextButton(
                  onPressed: () => appState.setPlayerOnCourt(player.id, false),
                  child: const Text('Bench'),
                ),
                onTap: () => appState.selectPlayer(player.id),
              ),
            ),
            const SizedBox(height: 12),
            Text('Bench', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (appState.benchPlayers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No bench players.'),
              )
            else
              ...appState.benchPlayers.map(
                (player) => ListTile(
                  leading: CircleAvatar(child: Text('#${player.jerseyNumber}')),
                  title: Text(player.displayName),
                  subtitle: const Text('Bench'),
                  trailing: FilledButton.tonal(
                    onPressed: appState.onCourtPlayerIds.length >= 5
                        ? null
                        : () => appState.setPlayerOnCourt(player.id, true),
                    child: const Text('Move in'),
                  ),
                  onTap: () => appState.selectPlayer(player.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190,
              mainAxisExtent: 88,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: appState.activeActions.length,
            itemBuilder: (context, index) {
              final action = appState.activeActions[index];
              final points = action.pointValue > 0
                  ? '+${action.pointValue}'
                  : '${action.pointValue}';
              return FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(120, 72),
                  backgroundColor: Color(action.color),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => appState.recordEvent(action.id),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(action.label, textAlign: TextAlign.center),
                    Text(
                      points,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentEvents extends StatelessWidget {
  const _RecentEvents({required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final playersById = {
      for (final player in appState.players) player.id: player,
    };
    final format = DateFormat('h:mm:ss a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Events', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: appState.currentEvents.take(30).map((event) {
              final player = playersById[event.playerId];
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  child: Text(player == null ? '?' : '#${player.jerseyNumber}'),
                ),
                title: Text(
                  '${event.actionLabelSnapshot} ${event.pointsSnapshot >= 0 ? '+' : ''}${event.pointsSnapshot}',
                  style: TextStyle(
                    decoration: event.isVoided
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text(
                  'Set ${event.setNumber} • ${format.format(event.occurredAt)}',
                ),
                trailing: event.isVoided
                    ? const Icon(Icons.block, size: 20)
                    : IconButton(
                        tooltip: 'Void event',
                        onPressed: () => _confirmVoid(context, event.id),
                        icon: const Icon(Icons.undo),
                      ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmVoid(BuildContext context, String eventId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Void event?'),
        content: const Text(
          'This keeps the event in history but removes it from Coach Score totals.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Void'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await appState.voidEvent(eventId);
    }
  }
}

class _ScoringControls extends StatelessWidget {
  const _ScoringControls({required this.appState, required this.onOpenReports});

  final AppState appState;
  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context) {
    final completed = appState.currentMatch?.status == MatchStatus.completed;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: completed
              ? null
              : () => _confirm(context, 'Move to next set?', appState.nextSet),
          icon: const Icon(Icons.skip_next),
          label: const Text('Next Set'),
        ),
        OutlinedButton.icon(
          onPressed: completed
              ? null
              : () => _confirm(
                  context,
                  'Void the last event?',
                  appState.undoLastEvent,
                ),
          icon: const Icon(Icons.undo),
          label: const Text('Undo'),
        ),
        OutlinedButton.icon(
          onPressed: onOpenReports,
          icon: const Icon(Icons.bar_chart),
          label: const Text('Summary'),
        ),
        FilledButton.tonalIcon(
          onPressed: completed
              ? null
              : () => _confirm(
                  context,
                  'Finish this match?',
                  appState.finishCurrentMatch,
                ),
          icon: const Icon(Icons.flag),
          label: const Text('Finish Match'),
        ),
      ],
    );
  }

  Future<void> _confirm(
    BuildContext context,
    String message,
    Future<void> Function() action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await action();
    }
  }
}
