import 'package:example/home/home_view.dart';
import 'package:example/settings/settings_view.dart';

import 'package:md_engine/md_engine.dart';

void main() {
  final routes = <QRoute>[
    QRoute(path: "/", builder: () => const HomeView()),
    QRoute(path: "/settings", builder: () => const SettingsView()),
  ];

  MdApp.I.run(
    httpDriverOptions: MdHttpDriverOptions(
      accessToken: () async => "",
      uToken: () async => "",
      baseUrl: ({key}) => "",
      apiKey: ({key}) => "",
    ),
    routes: routes,
  );
}

/*void main() {
  int value = 0;

  MdObs test = value.obs();

  Timer.periodic(const Duration(milliseconds: 100), (timer) {
    if (test.hasChange) {
      print("TEVE MUDANÇA");
    }
  });

  Future.delayed(const Duration(seconds: 1), () {
    value = 2;
  });
}

extension IntObsExt on int {
  MdObs obs() {
    print("VALUE aa ${this.hashCode}");
    return MdObs(
      checker: () => this,
    );
  }
}*/

class MdObs {
  late Object? snapshot;
  final Object? Function() checker;

  MdObs({
    required this.checker,
  }) {
    snapshot = checker();
  }

  bool get hasChange {
    final result = snapshot != checker();
    snapshot = checker();
    return result;
  }
}
