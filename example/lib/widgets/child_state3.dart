import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';

class ChildState3 extends StatefulWidget {
  const ChildState3({super.key});

  @override
  State<ChildState3> createState() => _ChildState3State();
}

class _ChildState3State extends MdWidgetState<ChildState3> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Text("Sub3 counter: $counter"),
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: () {
            counter++;
          },
          child: const Text("Sub3 increment"),
        ),
      ],
    );
  }

  @override
  List<Object?> get observables => [counter];
}
