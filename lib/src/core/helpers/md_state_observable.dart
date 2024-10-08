abstract class MdStateObservable {
  MdStateObservable() {
    print("akiii");
    assert(
      observables.whereType<Function>().isEmpty,
      'Error on (${toString()}). **"Function" type is not suported to observables.**',
    );
    assert(
      observables.whereType<List>().isEmpty,
      'Error on (${toString()}). **"List" type is not suported to observables. Please use MdList.**',
    );
    assert(
      observables.whereType<List>().isEmpty,
      'Error on (${toString()}). **"Map" type is not suported to observables. Please use MdMap.**',
    );
    assert(
      observables.whereType<List>().isEmpty,
      'Error on (${toString()}). **"Set" type is not suported to observables. Please use MdSet.**',
    );
  }
  List<Object?> get observables;
}
