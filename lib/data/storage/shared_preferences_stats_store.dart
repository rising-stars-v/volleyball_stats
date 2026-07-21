import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/persistent_stats_repository.dart';
import 'json_stats_store.dart';

class SharedPreferencesStatsStore implements JsonStatsStore {
  static const _key = 'volleyball_stats_snapshot_v1';

  @override
  Future<Map<String, Object?>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null || saved.isEmpty) {
      return null;
    }
    return decodeSnapshot(saved);
  }

  @override
  Future<void> save(Map<String, Object?> snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, encodeSnapshot(snapshot));
  }
}
