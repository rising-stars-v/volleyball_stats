import 'package:flutter/material.dart';

import '../../app/app_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final match = appState.currentMatch;
    final summary = appState.currentSummary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Summary'),
        actions: [
          IconButton(
            tooltip: 'Share CSV',
            onPressed: match == null ? null : appState.shareCurrentMatch,
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: match == null
          ? const Center(
              child: Text('Start or select a match to view reports.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: Text(match.opponent),
                    subtitle: Text(
                      'Rule version ${match.ruleSetVersion} • Set ${match.currentSet} • ${match.status.name}',
                    ),
                    trailing: Text(
                      '${summary.overallCoachScore >= 0 ? '+' : ''}${summary.overallCoachScore}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Coach Score by Player',
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Player')),
                      DataColumn(label: Text('Events')),
                      DataColumn(label: Text('Score')),
                    ],
                    rows: summary.playerScores
                        .map(
                          (score) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  '#${score.player.jerseyNumber} ${score.player.displayName}',
                                ),
                              ),
                              DataCell(Text('${score.eventCount}')),
                              DataCell(Text(_points(score.score))),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                _Section(
                  title: 'Totals by Action',
                  child: _KeyValueList(
                    values: summary.totalsByAction.map(
                      (key, value) => MapEntry(key, _points(value)),
                    ),
                  ),
                ),
                _Section(
                  title: 'Totals by Set',
                  child: _KeyValueList(
                    values: summary.totalsBySet.map(
                      (key, value) => MapEntry('Set $key', _points(value)),
                    ),
                  ),
                ),
                _Section(
                  title: 'Event Counts',
                  child: _KeyValueList(
                    values: {
                      'Positive events': '${summary.positiveEventCount}',
                      'Negative events': '${summary.negativeEventCount}',
                      'Overall Coach Score': _points(summary.overallCoachScore),
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showTextExport(
                        context,
                        title: 'CSV export',
                        value: appState.currentMatchCsv(),
                      ),
                      icon: const Icon(Icons.table_view),
                      label: const Text('CSV Export'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        final value = await appState.backupJson();
                        if (!context.mounted) {
                          return;
                        }
                        await _showTextExport(
                          context,
                          title: 'JSON backup',
                          value: value,
                        );
                      },
                      icon: const Icon(Icons.data_object),
                      label: const Text('JSON Backup'),
                    ),
                    OutlinedButton.icon(
                      onPressed: appState.shareCurrentMatch,
                      icon: const Icon(Icons.ios_share),
                      label: const Text('Share CSV'),
                    ),
                    OutlinedButton.icon(
                      onPressed: appState.shareBackup,
                      icon: const Icon(Icons.backup),
                      label: const Text('Share Backup'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _showTextExport(
    BuildContext context, {
    required String title,
    required String value,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 700,
          child: SingleChildScrollView(child: SelectableText(value)),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _points(int value) => value > 0 ? '+$value' : '$value';
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(padding: const EdgeInsets.all(8), child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueList extends StatelessWidget {
  const _KeyValueList({required this.values});

  final Map<String, String> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('No events recorded.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values.entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 180, child: Text(entry.key)),
                  Text(
                    entry.value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
