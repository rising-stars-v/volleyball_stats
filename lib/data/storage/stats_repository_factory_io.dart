import '../repositories/persistent_stats_repository.dart';
import '../repositories/stats_repository.dart';
import 'sqlite_stats_store.dart';

StatsRepository createStatsRepository() {
  return PersistentStatsRepository(SqliteStatsStore());
}
