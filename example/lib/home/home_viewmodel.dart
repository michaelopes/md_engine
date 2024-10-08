import 'package:md_engine/md_engine.dart';

class HomeViewModel extends MdViewModel {
  HomeViewModel();

  int counter = 0;
  var counterObj = TestCounterObject();

  final map = MdMap<int, int>();
  final set = MdSet<int>({});
  @override
  List<Object?> get observables {
    return [
      counter,
      counterObj,
      map,
      set,
    ];
  }

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
  List<Object?> get observables => [counter];
}
