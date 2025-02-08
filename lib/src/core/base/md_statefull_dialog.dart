import 'package:flutter/material.dart';
import 'package:md_engine/src/core/util/md_extensions.dart';
import 'package:md_engine/src/widgets/md_will_pop_scope.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../util/md_toolkit.dart';

abstract class MdStatefullDialog extends StatefulWidget {
  const MdStatefullDialog({super.key});

  Future<dynamic> show(
    BuildContext context, {
    Color? barrierColor,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      builder: (_) => MdWillPopScope(
        onWillPop: () async => false,
        child: this,
      ),
      barrierDismissible: barrierDismissible,
      useSafeArea: false,
      useRootNavigator: true,
      barrierColor: barrierColor ??
          MdToolkit.I
              .getColorInverted(
                Theme.of(context).colorScheme.surface,
              )
              .withOpacity(.35),
    );
  }

  void hide(BuildContext context) async {
    await QR.popAllUntilThis(context);
  }
}
