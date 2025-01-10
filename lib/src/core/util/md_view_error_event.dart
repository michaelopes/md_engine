import 'package:md_engine/src/core/util/md_typedefs.dart';

final class MdViewErrorEvent {
  final ErrorOnShowCallback onShow;
  final ErrorOnBackCallback onGlobalBack;

  MdViewErrorEvent({
    required this.onShow,
    required this.onGlobalBack,
  });
}
