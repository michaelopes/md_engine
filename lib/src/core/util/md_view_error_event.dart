import 'package:md_engine/src/core/util/md_typedefs.dart';

final class MdViewErrorEvent {
  final ErrorOnShowCallback onShow;
  final ErrorOnBackCallback onBack;

  MdViewErrorEvent({
    required this.onShow,
    required this.onBack,
  });
}
