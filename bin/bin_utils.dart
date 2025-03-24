import 'dart:async';
import 'dart:io';

class BinUtils {
  Timer? debounceTimer;
  void watch(String path, void Function() callback) {
    final dir = Directory(path);
    _watchDirectory(dir, callback);
  }

  void _watchDirectory(Directory directory, void Function() callback) {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    directory.watch(events: FileSystemEvent.all).listen((event) {
      debounceTimer?.cancel();
      debounceTimer = Timer(Duration(milliseconds: 50), () {
        callback();
      });
    });

    // Monitorar subdiretórios também
    for (var entity in directory.listSync(recursive: true)) {
      if (entity is Directory) {
        _watchDirectory(entity, callback);
      }
    }
  }
}
