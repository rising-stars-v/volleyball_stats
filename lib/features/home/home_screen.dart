import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../features/matches/matches_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/roster/roster_screen.dart';
import '../../features/rules/rules_screen.dart';
import '../../features/scoring/scoring_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final screens = [
      MatchesScreen(appState: appState, onOpenScoring: () => _select(3)),
      RosterScreen(appState: appState),
      RulesScreen(appState: appState),
      ScoringScreen(
        appState: appState,
        onOpenMatches: () => _select(0),
        onOpenReports: () => _select(4),
      ),
      ReportsScreen(appState: appState),
    ];

    if (appState.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              if (!wide) {
                return screens[selectedIndex];
              }
              return Row(
                children: [
                  NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: _select,
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.sports_volleyball_outlined),
                        selectedIcon: Icon(Icons.sports_volleyball),
                        label: Text('Matches'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.groups_outlined),
                        selectedIcon: Icon(Icons.groups),
                        label: Text('Roster'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.tune_outlined),
                        selectedIcon: Icon(Icons.tune),
                        label: Text('Rules'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.scoreboard_outlined),
                        selectedIcon: Icon(Icons.scoreboard),
                        label: Text('Scoring'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bar_chart_outlined),
                        selectedIcon: Icon(Icons.bar_chart),
                        label: Text('Reports'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: screens[selectedIndex]),
                ],
              );
            },
          ),
          if (appState.errorMessage != null)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: Text(appState.errorMessage!),
                  trailing: IconButton(
                    tooltip: 'Dismiss',
                    onPressed: appState.clearError,
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar:
          MediaQuery.sizeOf(context).width >= 900 ||
              (selectedIndex == 3 && appState.currentMatch != null)
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: _select,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.sports_volleyball_outlined),
                  selectedIcon: Icon(Icons.sports_volleyball),
                  label: 'Matches',
                ),
                NavigationDestination(
                  icon: Icon(Icons.groups_outlined),
                  selectedIcon: Icon(Icons.groups),
                  label: 'Roster',
                ),
                NavigationDestination(
                  icon: Icon(Icons.tune_outlined),
                  selectedIcon: Icon(Icons.tune),
                  label: 'Rules',
                ),
                NavigationDestination(
                  icon: Icon(Icons.scoreboard_outlined),
                  selectedIcon: Icon(Icons.scoreboard),
                  label: 'Score',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
              ],
            ),
    );
  }

  void _select(int index) {
    setState(() => selectedIndex = index);
  }
}
