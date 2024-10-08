class MdMemoryCacheItem {
  final String id;
  final dynamic data;
  MdMemoryCacheItem({
    required this.id,
    required this.data,
  });
}

abstract class IMdMemoryCache {
  void add(MdMemoryCacheItem cache);
  void remove(String cacheId);
  void removeAll();
  bool exists(String cacheId);
  MdMemoryCacheItem get(String cacheId);
}

class FPMemoryCache implements IMdMemoryCache {
  static final FPMemoryCache _instance = FPMemoryCache._internal();
  FPMemoryCache._internal();
  factory FPMemoryCache() {
    return _instance;
  }

  final List<MdMemoryCacheItem> _store = [];

  @override
  void add(MdMemoryCacheItem cache) {
    if (_store.where((e) => e.id == cache.id).isNotEmpty) {
      _store.removeWhere((e) => e.id == cache.id);
      _store.add(cache);
    } else {
      _store.add(cache);
    }
  }

  @override
  void remove(String cacheId) {
    _store.removeWhere((e) => e.id == cacheId);
  }

  @override
  bool exists(String cacheId) {
    return _store.where((e) => e.id == cacheId).isNotEmpty;
  }

  @override
  MdMemoryCacheItem get(String cacheId) {
    return _store.firstWhere((e) => e.id == cacheId);
  }

  @override
  void removeAll() {
    _store.clear();
  }
}
