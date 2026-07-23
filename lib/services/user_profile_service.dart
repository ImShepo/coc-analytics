import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Legacy local keys — migrated once into Firestore, then removed.
const kLegacyLinkedPlayerTagKey = 'linked_player_tag';
const kLegacyLinkDeferredKey = 'link_player_deferred';

class UserProfile {
  final String? linkedPlayerTag;
  final bool linkDeferred;

  const UserProfile({
    this.linkedPlayerTag,
    this.linkDeferred = false,
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

  Future<void> _clearLegacyPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kLegacyLinkedPlayerTagKey);
    await prefs.remove(kLegacyLinkDeferredKey);
  }
}
