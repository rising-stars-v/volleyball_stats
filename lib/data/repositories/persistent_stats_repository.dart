import 'dart:convert';

import '../storage/json_stats_store.dart';
import 'in_memory_stats_repository.dart';

class PersistentStatsRepository extends InMemoryStatsRepository {
  PersistentStatsRepository(this._store);

  final JsonStatsStore _store;

  @override
  Future<void> initialize() async {
    final saved = await _store.load();
    if (saved != null) {
      loadSnapshot(saved);
    }
    await super.initialize();
  }

  @override
  Future<void> afterWrite() async {
    await _store.save(await exportBackup());
  }
}

Map<String, Object?> decodeSnapshot(String value) {
  return Map<String, Object?>.from(jsonDecode(value) as Map);
}

String encodeSnapshot(Map<String, Object?> snapshot) {
  return jsonEncode(snapshot);
}
