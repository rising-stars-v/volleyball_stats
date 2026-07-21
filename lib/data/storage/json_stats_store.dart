abstract class JsonStatsStore {
  Future<Map<String, Object?>?> load();
  Future<void> save(Map<String, Object?> snapshot);
}
