class MemoryCache<T> {
  MemoryCache({this.ttl = const Duration(minutes: 5)});

  final Duration ttl;
  final Map<String, _CacheEntry<T>> _store = {};

  T? get(String key) {
    final entry = _store[key];
    if (entry == null || entry.isExpired) {
      _store.remove(key);
      return null;
    }
    return entry.value;
  }

  void set(String key, T value) {
    _store[key] = _CacheEntry(value, DateTime.now().add(ttl));
  }
}

class _CacheEntry<T> {
  _CacheEntry(this.value, this.expiresAt);

  final T value;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
