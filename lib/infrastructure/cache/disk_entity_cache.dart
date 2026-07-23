import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DiskCacheEntry {
  final DateTime fetchedAt;
  final Map<String, dynamic> payload;

  const DiskCacheEntry({
    required this.fetchedAt,
    required this.payload,
  });
}

/// Persists API JSON payloads keyed by entity id (player tag, clan tag, …).
class DiskEntityCache {
  DiskEntityCache(this._keyPrefix);

  final String _keyPrefix;

  String _storageKey(String id) => '$_keyPrefix$id';

  Future<DiskCacheEntry?> read(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey(id));
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final fetchedAtMs = map['fetchedAt'];
      final payload = map['payload'];
      if (fetchedAtMs is! int || payload is! Map<String, dynamic>) {
        await prefs.remove(_storageKey(id));
        return null;
      }
      return DiskCacheEntry(
        fetchedAt: DateTime.fromMillisecondsSinceEpoch(fetchedAtMs),
        payload: payload,
      );
    } catch (_) {
      await prefs.remove(_storageKey(id));
      return null;
    }
  }

  Future<void> write(String id, Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey(id),
      jsonEncode({
        'fetchedAt': DateTime.now().millisecondsSinceEpoch,
        'payload': payload,
      }),
    );
  }

  Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey(id));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
