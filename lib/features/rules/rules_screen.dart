import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../data/models/rule_action.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final ruleSet = appState.activeRuleSet;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Score Rules'),
        actions: [
          IconButton(
            tooltip: 'Add action',
            onPressed: () => _editAction(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              ruleSet == null
                  ? 'No rule set configured.'
                  : '${ruleSet.name} • version ${ruleSet.version}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: appState.actions.length,
              onReorderItem: appState.reorderAction,
              itemBuilder: (context, index) {
                final action = appState.actions[index];
                return Card(
                  key: ValueKey(action.id),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(action.color),
                      foregroundColor: Colors.white,
                      child: Text(_points(action.pointValue)),
                    ),
                    title: Text(action.label),
                    subtitle: Text('${action.category} • order ${index + 1}'),
                    trailing: Switch(
                      value: action.active,
                      onChanged: (value) => appState.saveAction(
                        id: action.id,
                        category: action.category,
                        label: action.label,
                        pointValue: action.pointValue,
                        color: action.color,
                        active: value,
                      ),
                    ),
                    onTap: () => _editAction(context, action: action),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editAction(context),
        icon: const Icon(Icons.add),
        label: const Text('Action'),
      ),
    );
  }

  Future<void> _editAction(BuildContext context, {RuleAction? action}) async {
    final categoryController = TextEditingController(
      text: action?.category ?? '',
    );
    final labelController = TextEditingController(text: action?.label ?? '');
    final pointsController = TextEditingController(
      text: action == null ? '1' : '${action.pointValue}',
    );
    var active = action?.active ?? true;
    var color = action?.color ?? 0xFF006B5B;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(action == null ? 'Add action' : 'Edit action'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(labelText: 'Label'),
                ),
                TextField(
                  controller: pointsController,
                  decoration: const InputDecoration(
                    labelText: 'Coach Score points',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        0xFF006B5B,
                        0xFF1565C0,
                        0xFF2E7D32,
                        0xFF6A1B9A,
                        0xFFC62828,
                        0xFFEF6C00,
                      ].map((candidate) {
                        return ChoiceChip(
                          selected: color == candidate,
                          label: const SizedBox(width: 28, height: 28),
                          avatar: CircleAvatar(
                            backgroundColor: Color(candidate),
                          ),
                          onSelected: (_) => setState(() => color = candidate),
                        );
                      }).toList(),
                ),
                SwitchListTile(
                  value: active,
                  onChanged: (value) => setState(() => active = value),
                  title: const Text('Active'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await appState.saveAction(
        id: action?.id,
        category: categoryController.text,
        label: labelController.text,
        pointValue: int.tryParse(pointsController.text.trim()) ?? 0,
        color: color,
        active: active,
      );
    }
  }

  String _points(int value) => value > 0 ? '+$value' : '$value';
}
