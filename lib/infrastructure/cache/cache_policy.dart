/// Cache TTLs for CoC API snapshots (not real-time game state).
abstract final class CachePolicy {
  static const playerDiskTtl = Duration(minutes: 15);
  static const clanDiskTtl = Duration(minutes: 10);
  static const memoryTtl = Duration(minutes: 5);

  /// Live war state. Memory only — a disk copy would lie after the next attack.
  static const currentWarTtl = Duration(seconds: 60);

  /// Refresh in background when app returns after this idle period.
  static const resumeRefreshAfter = Duration(minutes: 5);
}
