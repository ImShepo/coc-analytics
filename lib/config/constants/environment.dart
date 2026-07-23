import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  /// Base URL for Clash data requests.
  /// Release: Cloud Run proxy (see `.env.production`).
  /// Debug: local proxy — Android emulator `10.0.2.2`, iOS simulator `127.0.0.1`
  /// (see `.env.development`).
  static String get apiBaseUrl {
    final raw = dotenv.env['API_BASE_URL']?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError(
        'API_BASE_URL is missing. Use .env.development (debug) or .env.production (release).',
      );
    }
    return _localizeLoopback(raw);
  }

  /// True when pointing at the hosted Cloud Run proxy (not loopback).
  static bool get usesRemoteProxy {
    final base = apiBaseUrl.toLowerCase();
    return usesProxy &&
        !base.contains('10.0.2.2') &&
        !base.contains('127.0.0.1') &&
        !base.contains('localhost');
  }

  /// Android emulator reaches the host via 10.0.2.2; iOS simulator via 127.0.0.1.
  static String _localizeLoopback(String url) {
    if (kIsWeb) return url;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    if (isIos && url.contains('10.0.2.2')) {
      return url.replaceAll('10.0.2.2', '127.0.0.1');
    }
    if (isAndroid &&
        (url.contains('127.0.0.1') || url.contains('localhost'))) {
      return url
          .replaceAll('127.0.0.1', '10.0.2.2')
          .replaceAll('localhost', '10.0.2.2');
    }
    return url;
  }

  /// Only used for local/dev when calling Supercell directly (no proxy).
  /// Never put this in `.env.production` or Play Store builds.
  static String get cocKey => dotenv.env['COC_KEY'] ?? '';

  static bool get usesProxy {
    final base = apiBaseUrl.toLowerCase();
    return !base.contains('api.clashofclans.com');
  }
}
