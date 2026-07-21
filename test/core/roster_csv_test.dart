import 'package:flutter_test/flutter_test.dart';
import 'package:volleyball_stats/core/roster_csv.dart';

void main() {
  test('validates all rows before importing roster csv', () {
    final result = RosterCsvParser().parse(
      'jersey_number,name\n3,Alex\n3,Jordan\nx,Casey',
    );

    expect(result.isValid, isFalse);
    expect(result.errors, hasLength(2));
    expect(result.errors.join('\n'), contains('duplicates active jersey #3'));
    expect(result.errors.join('\n'), contains('invalid jersey number'));
  });

  test('parses valid roster csv', () {
    final result = RosterCsvParser().parse(
      'jersey_number,name\n3,Alex\n7,Jordan',
    );

    expect(result.isValid, isTrue);
    expect(result.players.map((player) => player.jerseyNumber), [3, 7]);
  });
}
