import 'package:flutter/material.dart';

import '../data/repositories/stats_repository.dart';
import '../data/storage/stats_repository_factory.dart';
import '../features/home/home_screen.dart';
import 'app_state.dart';

class VolleyballStatsApp extends StatefulWidget {
  const VolleyballStatsApp({super.key, this.repository});

  final StatsRepository? repository;

  @override
  State<VolleyballStatsApp> createState() => _VolleyballStatsAppState();
}

class _VolleyballStatsAppState extends State<VolleyballStatsApp> {
  late final AppState appState;

  @override
  void initState() {
    super.initState();
    appState = AppState(widget.repository ?? createStatsRepository());
    appState.initialize();
  }

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Coach Score',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF006B5B),
              brightness: Brightness.light,
            ),
            splashFactory: InkRipple.splashFactory,
            useMaterial3: true,
            visualDensity: VisualDensity.standard,
          ),
          home: HomeScreen(appState: appState),
        );
      },
    );
  }
}
