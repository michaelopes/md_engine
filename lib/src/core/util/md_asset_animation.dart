import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MdAssetAnimation {
  final String fileName;
  final double? width;
  final double? height;
  final BoxFit? fit;

  MdAssetAnimation({
    required this.fileName,
    this.width,
    this.height,
    this.fit,
  });

  Widget call({
    Animation<double>? controller,
    void Function(Duration)? onLoaded,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool? animate,
    bool? addRepaintBoundary,
    bool? repeat,
    AssetBundle? bundle,
    LottieDelegates? delegates,
    ImageErrorWidgetBuilder? errorBuilder,
    FilterQuality? filterQuality,
    FrameRate? frameRate,
    LottieImageProviderFactory? imageProviderFactory,
    Widget Function(BuildContext, Widget, LottieComposition?)? frameBuilder,
    LottieOptions? options,
    bool? reverse,
  }) {
    return Lottie.asset(
      fileName,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? (this.fit ?? BoxFit.contain),
      alignment: alignment,
      animate: animate,
      addRepaintBoundary: addRepaintBoundary,
      repeat: repeat,
      bundle: bundle,
      delegates: delegates,
      errorBuilder: errorBuilder,
      filterQuality: filterQuality,
      frameBuilder: frameBuilder,
      frameRate: frameRate,
      imageProviderFactory: imageProviderFactory,
      options: options,
      reverse: reverse,
      controller: controller,
      onLoaded: (composition) => onLoaded?.call(composition.duration),
    );
  }
}

/*

Lottie.memory(
                  snapshot.data!,
                  width: width ?? this.width,
                  height: height ?? this.height,
                  fit: fit ?? (this.fit ?? BoxFit.contain),
                  controller: controller,
                  onLoaded: (composition) =>
                      onLoaded?.call(composition.duration),
                )
 */