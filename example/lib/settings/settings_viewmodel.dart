import 'package:md_engine/md_engine.dart';

class SettingsViewModel extends MdViewModel {
  SettingsViewModel();

  int counter = 0;
  var counterObj = TestCounterObject();

  final map = MdMap<int, int>();
  final set = MdSet<int>({});
  @override
  List<MdStateObs> get observables => [
        () => counter,
        () => counterObj,
        () => map,
        () => set,
      ];

  @override
  Future<void> setup() async {}
}

// CLASSE EXEMPLICANDO UM OBJETO MODEL
final class TestCounterObject extends MdStateObservable {
  int counter = 0;
  List d = [];
  // final int t;

  //TestCounterObject(this.t);

  @override
  List<MdStateObs> get observables => [() => counter];
}
