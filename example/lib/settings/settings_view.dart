import 'package:example/settings/settings_viewmodel.dart';
import 'package:example/widgets/child_state.dart';
import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState
    extends MdViewModelState<SettingsView, SettingsViewModel> {
  _SettingsViewState() : super(SettingsViewModel());

  int _cou2 = 0;

  bool remove = false;

  int counter = QR.params["counter"]?.asInt ?? 0;

  @override
  void initState() {
    print("stateView $hashCode");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings $counter"),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  QR.toName("/settings", params: {"counter": counter + 1});
                },
                child: const Text("Settings"),
              ),
              const ChildState(),
              /*ValueListenableBuilder(
                valueListenable: _cou,
                builder: (_, __, ___) {
                  return Text("Vn Counter: ${_cou.value}");
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ValueListenableBuilder(
                valueListenable: _cou2,
                builder: (_, __, ___) {
                  return Text("Vn Counter 2: ${_cou.value}");
                },
              ),*/
              Text("Counter: ${vm.counter}"),
              const SizedBox(
                height: 12,
              ),
              Text("Counter obg: ${vm.counterObj.counter}"),
              const SizedBox(
                height: 12,
              ),
              Text("Map l: ${vm.map.length}"),
              const SizedBox(
                height: 12,
              ),
              Text("Set l: ${vm.set.length}"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  /*  _cou.value++;
                  _cou2.value++;*/
                  /*  vm.counter++;
                  vm.counterObj.counter++;*/
                  vm.set.addAll({_cou2++});
                },
                child: const Text("Increment"),
              ),
              const SizedBox(
                height: 20,
              ),
              if (!remove) const ChildState(),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    remove = true;
                  });
                },
                child: const Text("Remove"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
