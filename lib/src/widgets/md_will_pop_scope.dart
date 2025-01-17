import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class MdWillPopScope extends StatelessWidget {
  const MdWillPopScope({
    super.key,
    required this.onWillPop,
    required this.child,
  });

  final Future<bool> Function()? onWillPop;
  final Widget child;

  Future<void> _pop(Object? result, BuildContext context) async {
    if ((await onWillPop?.call()) ?? true) {
      QR.back(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _pop(result, context);
        }
      },
      child: child,
    );
  }
}
