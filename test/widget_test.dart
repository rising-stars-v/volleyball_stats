import 'package:flutter_test/flutter_test.dart';
import 'package:volleyball_stats/app/volleyball_app.dart';
import 'package:volleyball_stats/data/repositories/in_memory_stats_repository.dart';

void main() {
  testWidgets('app starts with seeded roster and match controls', (
    tester,
  ) async {
    final repository = InMemoryStatsRepository();
    await tester.pumpWidget(VolleyballStatsApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Volleyball Coach Score'), findsOneWidget);
    expect(find.text('Start Match'), findsOneWidget);
  });

  testWidgets('empty scoring screen keeps a route back to matches', (
    tester,
  ) async {
    final repository = InMemoryStatsRepository();
    await tester.pumpWidget(VolleyballStatsApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Score'));
    await tester.pumpAndSettle();

    expect(find.text('No active match'), findsOneWidget);
    expect(find.text('Go to Matches'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);

    await tester.tap(find.text('Go to Matches'));
    await tester.pumpAndSettle();

    expect(find.text('Start Match'), findsOneWidget);
  });

  testWidgets('active scoring screen has a matches button', (tester) async {
    final repository = InMemoryStatsRepository();
    await tester.pumpWidget(VolleyballStatsApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start Match'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start').last);
    await tester.pumpAndSettle();

    expect(find.text('Opponent • Set 1'), findsOneWidget);
    expect(find.byTooltip('Matches'), findsOneWidget);

    await tester.tap(find.byTooltip('Matches'));
    await tester.pumpAndSettle();

    expect(find.text('Resume Opponent'), findsOneWidget);
  });
}
