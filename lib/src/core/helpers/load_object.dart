class LoadObject {
  final String key;
  bool status;

  LoadObject({
    required this.status,
    this.key = "default",
  });

  factory LoadObject.showLoad({String key = "default"}) {
    return LoadObject(status: true, key: key);
  }

  factory LoadObject.hideLoad({String key = "default"}) {
    return LoadObject(status: false, key: key);
  }

  LoadObject copyWith({
    bool? status,
    String? key,
  }) {
    return LoadObject(
      status: status ?? this.status,
      key: key ?? this.key,
    );
  }
}
