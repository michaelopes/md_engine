import 'package:flutter/material.dart';

class MdResponsiveMetrics {
  late final Size size;
  MdResponsiveMetrics.of(BuildContext context) {
    size = MediaQuery.sizeOf(context);
  }

  MdResponsiveMetrics.fromSize(this.size);

  bool get isMobile {
    return size.width < 768;
  }

  bool get isTablet {
    return size.width >= 768 && size.width < 992;
  }

  bool get isDesktop {
    return size.width >= 992;
  }

  bool get isSM {
    return size.width < 768;
  }

  bool get isMD {
    return size.width >= 768 && size.width < 992;
  }

  bool get isLG {
    return size.width >= 992 && size.width < 1200;
  }

  bool get isXL {
    return size.width >= 1200;
  }
}
