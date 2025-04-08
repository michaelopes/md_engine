typedef MdGlobalNotificationListener = void Function(dynamic data);
typedef MdGlobalNotificationDisposer = void Function();

final class MdGlobalNotification {
  MdGlobalNotification._internal();
  static final MdGlobalNotification I = MdGlobalNotification._internal();
  final _store = <({
    String disposerRef,
    String key,
    MdGlobalNotificationListener listener
  })>[];

  MdGlobalNotificationDisposer listen({
    required String key,
    required MdGlobalNotificationListener listener,
  }) {
    final disposerRef = listener.hashCode.toString();
    final item = (disposerRef: disposerRef, key: key, listener: listener);
    _store.add(item);
    return () {
      _store.removeWhere((e) => e.disposerRef == disposerRef);
    };
  }

  void notify({
    required String key,
    dynamic data,
  }) {
    final filter = _store.where((e) => e.key == key);
    for (var item in filter) {
      item.listener(data);
    }
  }
}
