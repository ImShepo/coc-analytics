import 'dart:convert';

import 'package:coc/config/helpers/player_tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentCompareTag {
  final String tag;
  final String? name;

  const RecentCompareTag({
    required this.tag,
    this.name,
  });

  String get displayTag => playerTagToDisplay(tag);

  Map<String, dynamic> toJson() => {
        'tag': tag,
        if (name != null && name!.isNotEmpty) 'name': name,
      };

  factory RecentCompareTag.fromJson(Map<String, dynamic> json) {
    final rawName = (json['name'] as String?)?.trim();
    return RecentCompareTag(
      tag: normalizePlayerTag(json['tag'] as String? ?? ''),
      name: (rawName == null || rawName.isEmpty) ? null : rawName,
    );
  }
}

/// Device-local recent rival tags for the Compare search field.
abstract final class RecentCompareTagsStore {
  static const _prefsKey = 'compare_recent_rival_tags_v1';
  static const _maxEntries = 20;

  static Future<List<RecentCompareTag>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((e) => RecentCompareTag.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.tag.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<List<RecentCompareTag>> remember(
    String rawTag, {
    String? name,
  }) async {
    final tag = normalizePlayerTag(rawTag);
    if (tag.isEmpty) return load();

    final cleanedName = name?.trim();
    final current = await load();
    final next = <RecentCompareTag>[
      RecentCompareTag(
        tag: tag,
        name: (cleanedName == null || cleanedName.isEmpty) ? null : cleanedName,
      ),
      ...current.where((e) => e.tag != tag),
    ];
    if (next.length > _maxEntries) {
      next.removeRange(_maxEntries, next.length);
    }
    await _save(next);
    return next;
  }

  static Future<List<RecentCompareTag>> remove(String rawTag) async {
    final tag = normalizePlayerTag(rawTag);
    final next = (await load()).where((e) => e.tag != tag).toList();
    await _save(next);
    return next;
  }

  static Future<List<RecentCompareTag>> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    return const [];
  }

  static Future<void> _save(List<RecentCompareTag> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}
