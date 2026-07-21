import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../data/models/player.dart';

class RosterScreen extends StatelessWidget {
  const RosterScreen({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roster'),
        actions: [
          IconButton(
            tooltip: 'Import CSV',
            onPressed: () => _pickCsv(context),
            icon: const Icon(Icons.upload_file),
          ),
          IconButton(
            tooltip: 'Add player',
            onPressed: () => _editPlayer(context),
            icon: const Icon(Icons.person_add_alt),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _editPlayer(context),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Add Player'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _pickCsv(context),
            icon: const Icon(Icons.upload_file),
            label: const Text('Import CSV roster'),
          ),
          const SizedBox(height: 16),
          ...appState.players.map(
            (player) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('#${player.jerseyNumber}')),
                title: Text(player.displayName),
                subtitle: Text(player.active ? 'Active' : 'Inactive'),
                trailing: Switch(
                  value: player.active,
                  onChanged: (value) => appState.savePlayer(
                    id: player.id,
                    jerseyNumber: player.jerseyNumber,
                    displayName: player.displayName,
                    active: value,
                  ),
                ),
                onTap: () => _editPlayer(context, player: player),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCsv(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    final file = result?.files.single;
    if (file?.bytes == null || !context.mounted) {
      return;
    }
    final csvText = utf8.decode(file!.bytes!);
    final validation = appState.validateRosterCsv(csvText);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(validation.isValid ? 'Import roster' : 'CSV errors'),
        content: SingleChildScrollView(
          child: Text(
            validation.isValid
                ? 'Import ${validation.players.length} active players? Existing roster will be replaced.'
                : validation.errors.join('\n'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          if (validation.isValid)
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Import'),
            ),
        ],
      ),
    );
    if (confirmed == true) {
      await appState.importRosterCsv(csvText);
    }
  }

  Future<void> _editPlayer(BuildContext context, {Player? player}) async {
    final numberController = TextEditingController(
      text: player == null ? '' : '${player.jerseyNumber}',
    );
    final nameController = TextEditingController(
      text: player?.displayName ?? '',
    );
    var active = player?.active ?? true;
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(player == null ? 'Add player' : 'Edit player'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Jersey number'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Display name'),
              ),
              SwitchListTile(
                value: active,
                onChanged: (value) => setState(() => active = value),
                title: const Text('Active'),
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
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await appState.savePlayer(
        id: player?.id,
        jerseyNumber: int.tryParse(numberController.text.trim()) ?? -1,
        displayName: nameController.text,
        active: active,
      );
    }
  }
}
