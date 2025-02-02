import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';
import 'package:md_engine/src/widgets/md_will_pop_scope.dart';

class MdFullScreenLoading extends MdStateless {
  MdFullScreenLoading({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      routeSettings: RouteSettings(name: "modal-dialog"),
      builder: (_) {
        return MdFullScreenLoading();
      },
    );
  }

  static void hide(context) {
    final check = ModalRoute.isCurrentOf(context);
    if (check == false) {
      QR.back();
      return hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MdWillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: theme.colorScheme.surface.withOpacity(.3),
        child: SizedBox.expand(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
