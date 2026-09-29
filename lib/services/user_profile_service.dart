import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Legacy local keys — migrated once into Firestore, then removed.
const kLegacyLinkedPlayerTagKey = 'linked_player_tag';
const kLegacyLinkDeferredKey = 'link_player_deferred';
const kRivalTagKey = 'rival_player_tag';
const kTrophyPointsKey = 'trophy_points_v1';

class TrophyPoint {
  final DateTime at;
  final int trophies;
  final int warStars;

  const TrophyPoint({
    required this.at,
    required this.trophies,
    required this.warStars,
  });

  Map<String, dynamic> toJson() => {
        'at': at.toUtc().toIso8601String(),
        'trophies': trophies,
        'warStars': warStars,
      };

  static TrophyPoint? fromJson(Map<String, dynamic> json) {
    final at = DateTime.tryParse(json['at'] as String? ?? '');
    if (at == null) return null;
    return TrophyPoint(
      at: at.toUtc(),
      trophies: json['trophies'] as int? ?? 0,
      warStars: json['warStars'] as int? ?? 0,
    );
  }
}

class UserProfile {
  final String? linkedPlayerTag;
  final bool linkDeferred;
  final String? rivalTag;
  final List<TrophyPoint> trophyPoints;

  const UserProfile({
    this.linkedPlayerTag,
    this.linkDeferred = false,
    this.rivalTag,
    this.trophyPoints = const [],
  });

  static const empty = UserProfile();

  bool get hasLinkedPlayer =>
      linkedPlayerTag != null && linkedPlayerTag!.isNotEmpty;
}

/// Persists Clash player link on the signed-in Firebase user (`users/{uid}`).
class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const _timeout = Duration(seconds: 8);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<UserProfile?> fetch(String uid) async {
    final snap = await _userDoc(uid).get().timeout(_timeout);
    if (!snap.exists) return null;
    final data = snap.data() ?? const <String, dynamic>{};
    final rawTag = data['linkedPlayerTag'] as String?;
    final tag = (rawTag == null || rawTag.isEmpty)
        ? null
        : AuthService.playerTagForStorage(rawTag);
    return UserProfile(
      linkedPlayerTag: tag,
      linkDeferred: data['linkDeferred'] as bool? ?? false,
      rivalTag: _tagOrNull(data['rivalTag'] as String?),
      trophyPoints: _pointsFrom(data['trophyPoints']),
    );
  }

  /// Loads profile from Firestore. If missing, migrates legacy SharedPreferences
  /// values once. Soft-fails to local/empty when Firestore is unavailable.
  Future<UserProfile> loadAndMigrate(String uid) async {
    UserProfile? remote;
    try {
      remote = await fetch(uid);
    } catch (e, st) {
      debugPrint('UserProfile fetch failed: $e\n$st');
      remote = null;
    }

    if (remote != null &&
        (remote.hasLinkedPlayer || remote.linkDeferred)) {
      final prefs = await SharedPreferences.getInstance();
      if (remote.hasLinkedPlayer) {
        await prefs.setString(
          kLegacyLinkedPlayerTagKey,
          remote.linkedPlayerTag!,
        );
        await prefs.remove(kLegacyLinkDeferredKey);
      } else {
        await prefs.remove(kLegacyLinkedPlayerTagKey);
        await prefs.setBool(kLegacyLinkDeferredKey, true);
      }
      return remote;
    }

    final prefs = await SharedPreferences.getInstance();
    final localTag = prefs.getString(kLegacyLinkedPlayerTagKey);
    final localDeferred = prefs.getBool(kLegacyLinkDeferredKey) ?? false;

    if (localTag != null && localTag.isNotEmpty) {
      final normalized = AuthService.playerTagForStorage(localTag);
      await _tryWrite(() => setLinkedPlayerTag(uid, normalized));
      return UserProfile(linkedPlayerTag: normalized);
    }

    if (localDeferred) {
      await _tryWrite(() => setLinkDeferred(uid, true));
      return const UserProfile(linkDeferred: true);
    }

    if (remote != null) return remote;
    return UserProfile.empty;
  }

  Future<void> setLinkedPlayerTag(String uid, String rawTag) async {
    final normalized = AuthService.playerTagForStorage(rawTag);
    // Always keep a local mirror so auth routing works without Firestore.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLegacyLinkedPlayerTagKey, normalized);
    await prefs.remove(kLegacyLinkDeferredKey);

    try {
      await _userDoc(uid)
          .set(
            {
              'linkedPlayerTag': normalized,
              'linkDeferred': false,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(_timeout);
    } catch (e, st) {
      debugPrint('UserProfile setLinkedPlayerTag (remote) failed: $e\n$st');
      // Local mirror already saved — linking still works offline.
    }
  }

  Future<void> clearLinkedPlayerTag(String uid) async {
    await _clearLegacyPrefs();
    try {
      await _userDoc(uid)
          .set(
            {
              'linkedPlayerTag': FieldValue.delete(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(_timeout);
    } catch (e, st) {
      debugPrint('UserProfile clearLinkedPlayerTag failed: $e\n$st');
    }
  }

  Future<void> setLinkDeferred(String uid, bool deferred) async {
    final prefs = await SharedPreferences.getInstance();
    if (deferred) {
      await prefs.setBool(kLegacyLinkDeferredKey, true);
    } else {
      await prefs.remove(kLegacyLinkDeferredKey);
    }

    try {
      await _userDoc(uid)
          .set(
            {
              'linkDeferred': deferred,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(_timeout);
    } catch (e, st) {
      debugPrint('UserProfile setLinkDeferred (remote) failed: $e\n$st');
    }
  }

  Future<bool> _tryWrite(Future<void> Function() write) async {
    try {
      await write();
      return true;
    } catch (e, st) {
      debugPrint('UserProfile write failed: $e\n$st');
      return false;
    }
  }

  Future<void> setRivalTag(String uid, String rawTag) async {
    final normalized = AuthService.playerTagForStorage(rawTag);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kRivalTagKey, normalized);
    try {
      await _userDoc(uid)
          .set(
            {
              'rivalTag': normalized,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(_timeout);
    } catch (e, st) {
      debugPrint('UserProfile setRivalTag failed: $e\n$st');
    }
  }

  Future<void> clearRivalTag(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kRivalTagKey);
    try {
      await _userDoc(uid)
          .set(
            {
              'rivalTag': FieldValue.delete(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(_timeout);
    } catch (e, st) {
      debugPrint('UserProfile clearRivalTag failed: $e\n$st');
    }
  }

  Future<List<TrophyPoint>> recordTrophyPoint(
    String uid, {
    required int trophies,
    required int warStars,
    List<TrophyPoint> current = const [],
  }) async {
    final now = DateTime.now().toUtc();
    final next = List<TrophyPoint>.from(current);
    final sameDay = next.isNotEmpty &&
        next.last.at.toUtc().year == now.year &&
        next.last.at.toUtc().month == now.month &&
        next.last.at.toUtc().day == now.day;
    if (sameDay &&
        next.last.trophies == trophies &&
        next.last.warStars == warStars) {
      return current;
    }
    final point = TrophyPoint(at: now, trophies: trophies, warStars: warStars);
    if (sameDay) {
      next[next.length - 1] = point;
    } else {
      next.add(point);
    }
    if (next.length > 60) {
      next.removeRange(0, next.length - 60);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      kTrophyPointsKey,
      jsonEncode(next.map((point) => point.toJson()).toList()),
    );

    try {
      await _userDoc(uid)
          .set(
            {
              'trophyPoints': next.map((point) => point.toJson()).toList(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          )
          .timeout(_timeout);
    } catch (e, st) {
      debugPrint('UserProfile recordTrophyPoint failed: $e\n$st');
    }
    return next;
  }

  Future<({String? rivalTag, List<TrophyPoint> points})> readLocalRival() async {
    final prefs = await SharedPreferences.getInstance();
    final rival = _tagOrNull(prefs.getString(kRivalTagKey));
    final raw = prefs.getString(kTrophyPointsKey);
    return (rivalTag: rival, points: _pointsFrom(raw == null ? null : jsonDecode(raw)));
  }

  String? _tagOrNull(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return AuthService.playerTagForStorage(raw);
  }

  List<TrophyPoint> _pointsFrom(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => TrophyPoint.fromJson(Map<String, dynamic>.from(item)))
        .whereType<TrophyPoint>()
        .toList();
  }

  Future<void> _clearLegacyPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kLegacyLinkedPlayerTagKey);
    await prefs.remove(kLegacyLinkDeferredKey);
  }
}
