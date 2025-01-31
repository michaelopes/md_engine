import 'package:flutter/material.dart';
import 'package:md_engine/md_engine.dart';
import 'package:md_engine/src/widgets/md_will_pop_scope.dart';

class MdFullScreenLoading extends MdStateless {
  MdFullScreenLoading({super.key});

  Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MdWillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: theme.dialogTheme.barrierColor,
        child: SizedBox.expand(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
