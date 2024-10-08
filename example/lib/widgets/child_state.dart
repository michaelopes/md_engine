import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

import 'child_state2.dart';

class ChildState extends StatefulWidget {
  const ChildState({super.key});

  @override
  State<ChildState> createState() => _ChildStateState();
}

class _ChildStateState extends MdWidgetState<ChildState> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Text("Sub counter: $counter"),
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: () {
            counter++;
          },
          child: const Text("Sub increment"),
        ),
        const ChildState2(),
      ],
    );
  }

  @override
  List<Object?> get observables => [counter];
}
