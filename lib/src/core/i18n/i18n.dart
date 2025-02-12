import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class I18n {
  I18n._internal();

  static final I18n I = I18n._internal();

  static const _packageI18nPath = 'packages/md_engine/assets/i18n/';

  final List<String> availableLanguages = <String>[];
  late final Locale defaultLocale;
  late final Map<String, Map<String, dynamic>> values;

  Iterable<Locale> get supportedLocales => availableLanguages.map((language) {
        var splt = language.split("_");
        return Locale(splt.first, splt.length == 2 ? splt.last : "");
      });

  Future<void> init({
    required String filePath,
    required List<String> availableLanguages,
    required Locale defaultLocale,
    String? fallbackLanguage,
  }) async {
    if (availableLanguages.isNotEmpty) {
      this.availableLanguages.clear();
      this.availableLanguages.addAll(availableLanguages);
      this.defaultLocale = defaultLocale;

      if (fallbackLanguage == null && availableLanguages.isNotEmpty) {
        fallbackLanguage = availableLanguages.first;
      }

      values = {};
      for (var language in availableLanguages) {
        final appTranslation =
            json.decode(await _loadJsonFromAsset(language, filePath));
        final packageTranslation =
            json.decode(await _loadJsonFromAsset(language, _packageI18nPath));

        var fallbackTranslation = <String, dynamic>{};
        if (fallbackLanguage != null) {
          fallbackTranslation =
              json.decode(await _loadJsonFromAsset(fallbackLanguage, filePath));
        }
        final trCandidate = mergeMaps(packageTranslation, appTranslation);
        final translation = mergeMaps(trCandidate, fallbackTranslation);

        values[language] = _convertValueToString(translation);
      }
    }
  }

  Locale? localeResolutionCallback(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    if (supportedLocales.contains(deviceLocale)) {
      return deviceLocale ?? I18n.I.defaultLocale;
    } else if (deviceLocale != null) {
      final languageCode = deviceLocale.languageCode;
      if (languageCode == "pt") {
        return const Locale("pt", "BR");
      } else if (languageCode == "en") {
        return const Locale("en", "");
      } else if (languageCode == "es") {
        return const Locale("es", "");
      }
    }
    return I18n.I.defaultLocale;
  }

  Future<String> _loadJsonFromAsset(String language, String filePath) async {
    try {
      final bundle = _AssetBundle();
      return await bundle.loadString('$filePath$language.json');
    } on Exception {
      throw Exception('File "$language" not found $filePath');
    }
  }

  Map<String, dynamic> _convertValueToString(obj) {
    var result = <String, dynamic>{};
    obj.forEach((key, value) {
      result[key] = value;
    });
    return result;
  }

  Map<String, dynamic> mergeMaps(
      Map<String, dynamic> map1, Map<String, dynamic> map2) {
    Map<String, dynamic> result =
        Map.from(map1); // Copia o map1 para não modificar o original

    map2.forEach((key, value) {
      if (result.containsKey(key)) {
        // Se ambos forem mapas, faz a mesclagem recursivamente
        if (result[key] is Map<String, dynamic> &&
            value is Map<String, dynamic>) {
          result[key] = mergeMaps(result[key], value);
        } else {
          // Se não, sobrescreve o valor do map1 com o valor do map2
          result[key] = value;
        }
      } else {
        // Se a chave não existir no map1, adiciona do map2
        result[key] = value;
      }
    });

    return result;
  }
}

class _AssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final data = await load(key);
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<ByteData> load(String key) async => rootBundle.load(key);
}
