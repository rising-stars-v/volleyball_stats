import '../repositories/persistent_stats_repository.dart';
import '../repositories/stats_repository.dart';
import 'shared_preferences_stats_store.dart';

StatsRepository createStatsRepository() {
  return PersistentStatsRepository(SharedPreferencesStatsStore());
}
