import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/app_state.dart';
import '../../data/models/match_record.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    super.key,
    required this.appState,
    required this.onOpenScoring,
  });

  final AppState appState;
  final VoidCallback onOpenScoring;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volleyball Coach Score'),
        actions: [
          IconButton(
            tooltip: 'Start match',
            onPressed: () => _showStartMatch(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _showStartMatch(context),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Match'),
          ),
          const SizedBox(height: 16),
          if (appState.currentMatch != null &&
              appState.currentMatch!.status == MatchStatus.inProgress)
            Card(
              child: ListTile(
                leading: const Icon(Icons.scoreboard),
                title: Text('Resume ${appState.currentMatch!.opponent}'),
                subtitle: Text('Set ${appState.currentMatch!.currentSet}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpenScoring,
              ),
            ),
          const SizedBox(height: 8),
          Text('Recent Matches', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (appState.matches.isEmpty)
            const Text('No matches yet.')
          else
            ...appState.matches
                .take(20)
                .map(
                  (match) => Card(
                    child: ListTile(
                      leading: Icon(
                        match.status == MatchStatus.completed
                            ? Icons.check_circle_outline
                            : Icons.play_circle_outline,
                      ),
                      title: Text(match.opponent),
                      subtitle: Text(
                        '${dateFormat.format(match.matchDate)} • Set ${match.currentSet} • ${match.status.name}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await appState.resumeMatch(match.id);
                        onOpenScoring();
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _showStartMatch(BuildContext context) async {
    final opponentController = TextEditingController();
    final notesController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start match'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: opponentController,
              decoration: const InputDecoration(labelText: 'Opponent'),
              autofocus: true,
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );
    if (result == true && context.mounted) {
      await appState.startMatch(opponentController.text, notesController.text);
      onOpenScoring();
    }
  }
}
