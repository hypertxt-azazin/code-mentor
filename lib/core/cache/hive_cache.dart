import 'package:hive_flutter/hive_flutter.dart';

/// Thin wrapper around Hive providing simple key-value caching with optional TTL.
class HiveCache {
  static const _catalogBox = 'catalog';
  static const _lessonsBox = 'lessons';
  static const _metaBox = 'meta';

  /// Call once during app startup (after [Hive.initFlutter]).
  static Future<void> init() async {
    await Future.wait([
      Hive.openBox<dynamic>(_catalogBox),
      Hive.openBox<dynamic>(_lessonsBox),
      Hive.openBox<dynamic>(_metaBox),
    ]);
  }

  /// Opens (or returns an already-open) box by [boxName].
  Future<Box<dynamic>> openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) return Hive.box<dynamic>(boxName);
    return Hive.openBox<dynamic>(boxName);
  }

  /// Stores [value] in [boxName] under [key].
  Future<void> put(String key, dynamic value, {String boxName = _catalogBox}) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  /// Retrieves a value from [boxName] for [key]. Returns null if absent.
  dynamic get(String key, {String boxName = _catalogBox}) {
    if (!Hive.isBoxOpen(boxName)) return null;
    return Hive.box<dynamic>(boxName).get(key);
  }

  /// Stores [value] alongside a timestamp so TTL checks work.
  Future<void> putWithTTL(
    String key,
    dynamic value, {
    String boxName = _catalogBox,
  }) async {
    await Future.wait([
      put(key, value, boxName: boxName),
      put('${boxName}_${key}_ts', DateTime.now().toUtc().millisecondsSinceEpoch,
          boxName: _metaBox),
    ]);
  }

  /// Returns the cached value for [key] if it was stored within [ttl]; otherwise null.
  dynamic getWithTTL(String key, Duration ttl, {String boxName = _catalogBox}) {
    if (!Hive.isBoxOpen(boxName) || !Hive.isBoxOpen(_metaBox)) return null;

    final tsKey = '${boxName}_${key}_ts';
    final raw = Hive.box<dynamic>(_metaBox).get(tsKey);
    if (raw == null) return null;

    final storedAt = DateTime.fromMillisecondsSinceEpoch(raw as int, isUtc: true);
    if (DateTime.now().toUtc().difference(storedAt) > ttl) return null;

    return Hive.box<dynamic>(boxName).get(key);
  }

  /// Clears all entries in [boxName].
  Future<void> clear(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }
}
