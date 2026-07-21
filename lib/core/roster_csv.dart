import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';

import '../data/models/player.dart';

class RosterCsvResult {
  const RosterCsvResult({required this.players, required this.errors});

  final List<Player> players;
  final List<String> errors;

  bool get isValid => errors.isEmpty;
}

class RosterCsvParser {
  RosterCsvResult parse(String csvText, {Uuid uuid = const Uuid()}) {
    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvText.trim());
    final errors = <String>[];
    if (rows.isEmpty) {
      return const RosterCsvResult(players: [], errors: ['CSV is empty.']);
    }

    final header = rows.first
        .map((cell) => '$cell'.trim().toLowerCase())
        .toList();
    if (header.length < 2 ||
        header[0] != 'jersey_number' ||
        header[1] != 'name') {
      errors.add('Header must be exactly: jersey_number,name');
    }

    final seenNumbers = <int>{};
    final players = <Player>[];
    final now = DateTime.now();
    for (var i = 1; i < rows.length; i += 1) {
      final rowNumber = i + 1;
      final row = rows[i];
      if (row.every((cell) => '$cell'.trim().isEmpty)) {
        continue;
      }
      if (row.length < 2) {
        errors.add('Row $rowNumber must include jersey_number and name.');
        continue;
      }
      final jerseyText = '${row[0]}'.trim();
      final name = '${row[1]}'.trim();
      final jerseyNumber = int.tryParse(jerseyText);
      if (jerseyNumber == null || jerseyNumber < 0 || jerseyNumber > 999) {
        errors.add('Row $rowNumber has invalid jersey number "$jerseyText".');
        continue;
      }
      if (name.isEmpty) {
        errors.add('Row $rowNumber is missing a name.');
        continue;
      }
      if (!seenNumbers.add(jerseyNumber)) {
        errors.add('Row $rowNumber duplicates active jersey #$jerseyNumber.');
        continue;
      }
      players.add(
        Player(
          id: uuid.v4(),
          jerseyNumber: jerseyNumber,
          displayName: name,
          active: true,
          createdAt: now,
        ),
      );
    }

    if (players.isEmpty && errors.isEmpty) {
      errors.add('CSV has no player rows.');
    }
    return RosterCsvResult(players: players, errors: errors);
  }
}
