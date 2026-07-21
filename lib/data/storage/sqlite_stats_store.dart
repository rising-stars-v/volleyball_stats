import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../repositories/persistent_stats_repository.dart';
import 'json_stats_store.dart';

class SqliteStatsStore implements JsonStatsStore {
  static const _key = 'snapshot';

  Database? _database;

  Future<Database> get _db async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }
    final dbPath = await getDatabasesPath();
    final database = await openDatabase(
      path.join(dbPath, 'volleyball_stats.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE app_state (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
        );
      },
    );
    _database = database;
    return database;
  }

  @override
  Future<Map<String, Object?>?> load() async {
    final db = await _db;
    final rows = await db.query(
      'app_state',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [_key],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return decodeSnapshot(rows.single['value'] as String);
  }

  @override
  Future<void> save(Map<String, Object?> snapshot) async {
    final db = await _db;
    await db.insert('app_state', {
      'key': _key,
      'value': encodeSnapshot(snapshot),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
