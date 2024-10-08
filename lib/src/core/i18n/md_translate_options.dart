import 'package:flutter/widgets.dart';

final class MdTranslationOptions {
  final String filePath;
  final List<String> availableLanguages;
  final Locale defaultLocale;

  MdTranslationOptions({
    required this.filePath,
    required this.availableLanguages,
    required this.defaultLocale,
  });
}
