import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import 'child_state3.dart';

class ChildState2 extends StatefulWidget {
  const ChildState2({super.key});

  @override
  State<ChildState2> createState() => _ChildState2State();
}

class _ChildState2State extends MdWidgetState<ChildState2> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Text("Sub2 counter: $counter"),
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: () {
            counter++;
          },
          child: const Text("Sub2 increment"),
        ),
        const SizedBox(
          height: 12,
        ),
        const ChildState3(),
      ],
    );
  }

  @override
  List<MdStateObs> get observables => [() => counter];
}
