import 'dart:math';

import 'package:flutter/material.dart';

class MdRotatable extends StatelessWidget {
  final double degrees; // Graus para rotação
  final Widget child; // Widget a ser rotacionado

  // Construtor
  const MdRotatable({
    super.key,
    required this.degrees,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Converte os graus para radianos
    double radians = degrees * pi / 180;

    return Transform.rotate(
      angle: radians, // Aplica a rotação
      child: child,
    );
  }
}
