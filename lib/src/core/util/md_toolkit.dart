import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/md_icon.dart';
import 'md_masks.dart';

typedef WhenCondition = bool Function();

enum ImageFailbackType { user, community, communityCover, none }

class MdToolkit {
  MdToolkit._internal();

  static final MdToolkit I = MdToolkit._internal();

  String getFormatedReason(Object e, StackTrace s) {
    return "$e\n\n$s";
  }

  String brCellPhoneNormalize(String value) {
    var newV = removeSpecialCharacters(
      value.replaceAll("+55", "").replaceFirst("0", "").replaceAll("+550", ""),
    );

    if (newV.length > 10 && (newV.startsWith('55') || newV.startsWith('+55'))) {
      newV = newV.substring(2);
    }
    if (newV.startsWith("0")) {
      newV = newV.replaceFirst("0", "");
    }

    if (newV.length == 10) {
      var sub1 = newV.substring(0, 2);
      var sub2 = newV.substring(2, newV.length);
      return "${sub1}9$sub2";
    }

    return newV;
  }

  int getYearAge(DateTime date) {
    return (DateTime.now().difference(date).inDays / 365).ceil();
  }

  String strToB64(String str) {
    return base64.encode(utf8.encode(str));
  }

  String stringCrop(String str, int length) {
    if (str.length > length) {
      return "${str.substring(0, length)}...";
    } else {
      return str;
    }
  }

  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String convertMapToString(
    Map<String, dynamic> map, {
    String startSymbol = "{",
    String endSymbol = "}",
    String recusiveKeySymbol = ":",
    bool withoutQuotationMarks = false,
  }) {
    Object getVal(Object value) {
      if (isNumeric(value) || withoutQuotationMarks) {
        return value;
      } else if (value is List) {
        final lst = value.map((e) => getVal(e)).join(", ");
        return "[$lst]";
      } else if (value is Map) {
        return convertMapToString(Map<String, dynamic>.from(value));
      } else {
        return '"$value"';
      }
    }

    // Usando um StringBuffer para construir a string de forma eficiente
    StringBuffer buffer = StringBuffer();
    buffer.write(startSymbol);

    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        buffer.write(
            '$key$recusiveKeySymbol ${convertMapToString(value, startSymbol: "{", endSymbol: "}")}, ');
      } else {
        final val = getVal(value);
        buffer.write('$key: $val, ');
      }
    });

    String result = buffer.toString();
    result = result.substring(
        0, result.length - 2); // Remove a última vírgula e espaço
    result += endSymbol;

    return result;
  }

  String formatName(String name, {bool withCrop = false}) {
    var splited = name.trim().replaceAll("  ", "").split(" ");
    return splited.length > 1
        ? withCrop
            ? stringCrop("${splited.first} ${splited.last}", 15)
            : "${splited.first} ${splited.last}"
        : name;
  }

  String anonymizeDocument(String document) {
    final sanitizedCpf = document.replaceAll(RegExp(r'\D'), '');
    if (sanitizedCpf.length != 11) {
      return sanitizedCpf.length == 14
          ? MdMasks.I.cnpj.maskText(document)
          : document;
    }

    final anonymized =
        '***.${sanitizedCpf.substring(3, 6)}.${sanitizedCpf.substring(6, 9)}-**';
    return anonymized;
  }

  String formatDocument(String document) {
    final sanitizedCpf = document.replaceAll(RegExp(r'\D'), '');

    return sanitizedCpf.length == 14
        ? MdMasks.I.cnpj.maskText(document)
        : MdMasks.I.cpf.maskText(document);
  }

  String enumToString(Enum en, {bool withUnderscore = false}) {
    var splited = en.toString().split(".");
    final result = splited.length > 1 ? splited[1] : splited[0];
    return withUnderscore ? camelToUnderscore(result) : result;
  }

  T? enumFromString<T extends Enum>(List<T> ens, String? value) {
    if (value == null) return null;
    for (var item in ens) {
      if (enumToString(item) == value ||
          enumToString(item, withUnderscore: true) == value) {
        return item;
      }
    }
    return null;
  }

  double truncateToTwoDecimals(double value) {
    return (value * 100).truncateToDouble() / 100;
  }

  double truncateOrRound(double valor) {
    String valorStr =
        valor.toStringAsFixed(12); // Garante precisão para análise
    List<String> partes = valorStr.split('.');

    if (partes.length > 1 && partes[1].length > 2) {
      String decimais = partes[1];
      if (decimais.length > 1 && decimais[1] == '9') {
        return double.parse(valor.toStringAsFixed(1));
      }
    }

    return truncateToTwoDecimals(valor);
  }

  double sumPercentageOnValue(double value, percentage) {
    return value + (value * (percentage / 100));
  }

  String convertCase(String input) {
    if (input.contains('-')) {
      return input.split('-').map((word) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join('');
    } else if (input.contains(RegExp(r'[A-Z]'))) {
      return input
          .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'),
              (Match m) => '${m[1]}-${m[2]!.toLowerCase()}')
          .toLowerCase();
    } else {
      return input;
    }
  }

  String camelToUnderscore(String text) {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    String result = text
        .replaceAllMapped(exp, (Match m) => ('_${m.group(0)}'))
        .toLowerCase();
    return result;
  }

  String snakeCaseToCamelCase(String input) {
    List<String> parts = input.split('_');
    String camelCase = '';
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (i == 0) {
        camelCase += part;
      } else {
        camelCase += part[0].toUpperCase() + part.substring(1);
      }
    }
    return camelCase;
  }

  Color mergeColors(Color color1, Color color2) {
    return Color.fromARGB(
      (color1.alpha + color2.alpha) ~/ 2,
      (color1.red + color2.red) ~/ 2,
      (color1.green + color2.green) ~/ 2,
      (color1.blue + color2.blue) ~/ 2,
    );
  }

  String getNameInitials(String name) {
    List<String> words = name.split(" ");
    if (words.length > 1) {
      String first = words[0];
      String last = words[words.length - 1];
      return "${first[0]}${last[0]}".toUpperCase();
    } else {
      return name.substring(0, 2).toUpperCase();
    }
  }

  String clearString(String text) {
    return removeDiacritics(text);
  }

  String formatSematicDatetime(DateTime date,
      {String? locale, bool withSeconds = false}) {
    var format =
        DateFormat("dd MMMM yyyy, HH:mm${withSeconds ? ":ss" : ""}", locale);
    return format.format(date);
  }

  String dateToSemanticDateWithoutYear(DateTime date,
      {bool uppercase = false, bool fullWeekDay = false}) {
    var weekF = fullWeekDay ? "EEEE" : "EEE";
    var format = DateFormat("$weekF, dd MMM HH:mm");
    return uppercase ? format.format(date).toUpperCase() : format.format(date);
  }

  String dateToSemanticDateWithFullWeekDay(DateTime date,
      {bool uppercase = false}) {
    var format = DateFormat("EEEE, dd MMM HH:mm");
    if (uppercase) {
      var split = format.format(date).split(",");
      return "${capitalize(split[0])}, ${split[1].toUpperCase()}";
    }
    return format.format(date);
  }

  String formatBrDate(DateTime date) {
    var format = DateFormat("dd/MM/yyyy", "pt_BR");
    return format.format(date);
  }

  String formatISODate(DateTime date) {
    var format = DateFormat("yyyy-MM-dd");
    return format.format(date);
  }

  String formatBrDatetime(DateTime date) {
    var format = DateFormat("dd/MM/yyyy HH:mm", "pt_BR");
    return format.format(date);
  }

  DateTime convertBrDateStrToDateTime(String brStrDate) {
    var formated = brDatetime2IsoDatetime(brStrDate);
    return DateTime.parse(formated);
  }

  String getSemantcDayAndMonth() {
    var format = DateFormat(
      "dd of MMMM",
    );
    return format.format(DateTime.now());
  }

  String formatMoney(
    double value, {
    String simbol = "R\$ ",
    String locale = "pt_BR",
  }) {
    final formatedPrice = NumberFormat("#,##0.00", locale);
    return simbol.isNotEmpty
        ? "$simbol${formatedPrice.format(value)}"
        : formatedPrice.format(value);
  }

  String brDatetime2IsoDate(
    String brDate, {
    String? timePreposition,
  }) {
    var split1 = brDate.split(" ");
    String date = "";
    String time = "";
    if (split1.length > 1) {
      date = split1[0];
      time = (timePreposition ?? " ") + split1[1].substring(0, 5);
    } else {
      date = brDate;
    }
    var split2 = date.split("/");
    if (split2.length == 3) {
      return "${split2[2]}-${split2[1]}-${split2[0]}$time";
    } else {
      return "";
    }
  }

  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  String getObjValue(dynamic obj, int propIndex, List propArr) {
    var prop = propArr[propIndex];
    if (propIndex == propArr.length - 1) {
      return obj[prop].toString().toLowerCase();
    } else {
      return getObjValue(obj[prop], propIndex + 1, propArr);
    }
  }

  List<T> orderList<T>(String order, String fieldOrder, List<T> list) {
    var propArr = fieldOrder.split(".");
    return list
      ..sort((a, b) {
        var mapA = (a as dynamic).toMap();
        var mapB = (b as dynamic).toMap();
        var valueA = getObjValue(mapA, 0, propArr);
        var valueB = getObjValue(mapB, 0, propArr);
        if (order == "asc") {
          return valueA.compareTo(valueB);
        } else {
          return valueB.compareTo(valueA);
        }
      });
  }

  String ofuscateEmail(String email) {
    var splited = email.split("@");
    var counter = splited[0].length;
    var firtPart = splited[0].substring(0, 2);
    for (var i = 2; i < counter; i++) {
      firtPart += "*";
    }
    return "$firtPart@${splited[1]}";
  }

  String getRandomString({int length = 8}) {
    var chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(
          rnd.nextInt(chars.length),
        ),
      ),
    ).toUpperCase();
  }

  Future<void> when(
      WhenCondition condition, VoidCallback executor, int milliseconds) async {
    var limitSum = 0;
    Timer.periodic(Duration(milliseconds: milliseconds), (timer) {
      if (condition()) {
        executor();
        timer.cancel();
      } else if (limitSum > 500) {
        timer.cancel();
      }
      limitSum++;
    });
  }

  int colorToInt(Color color) {
    var result = int.parse(
            '${color.red.toRadixString(16).padLeft(2, '0')}'
            '${color.green.toRadixString(16).padLeft(2, '0')}'
            '${color.blue.toRadixString(16).padLeft(2, '0')}',
            radix: 16) +
        0xFF000000;
    return result;
  }

  Widget tryChangeIconColor({
    required Widget icon,
    required Color targetColor,
  }) {
    if (icon is Icon) {
      return Icon(
        icon.icon,
        size: icon.size,
        fill: icon.fill,
        grade: icon.grade,
        weight: icon.weight,
        opticalSize: icon.opticalSize,
        semanticLabel: icon.semanticLabel,
        shadows: icon.shadows,
        color: targetColor,
      );
    } else if (icon is MdIcn) {
      return icon.copyWith(
        color: MdToolkit.I.getColorInverted(targetColor),
      );
    }
    return icon;
  }

  Color getColorInverted(Color tColor) {
    if (ThemeData.estimateBrightnessForColor(tColor) == Brightness.dark) {
      return const Color(0xFFF6F6F8);
    }
    return const Color(0xFF1A191B);
  }

  String durationToMinuteFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMinutesFormated =
        duration.inHours <= 0 && duration.inMinutes < 10
            ? duration.inMinutes.toString()
            : twoDigitMinutes;
    return "${duration.inHours > 0 ? "${twoDigits(duration.inHours)}:" : ""}$twoDigitMinutesFormated:$twoDigitSeconds";
  }

  String durationToSematicFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = duration.inMinutes.remainder(60).toString();
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? "${duration.inHours}h " : ""}${twoDigitMinutes}m ${twoDigitSeconds != "00" && duration.inHours == 0 ? "${twoDigitSeconds}s" : ""}";
  }

  String fileSizeFormat(dynamic size, [int round = 2]) {
    var divider = 1024;
    int size0;
    try {
      size0 = int.parse(size.toString());
    } catch (e) {
      throw ArgumentError('Can not parse the size parameter: $e');
    }

    if (size0 < divider) {
      return '${size0}B';
    }

    if (size0 < divider * divider && size0 % divider == 0) {
      return '${(size0 / divider).toStringAsFixed(0)}KB';
    }

    if (size0 < divider * divider) {
      return '${(size0 / divider).toStringAsFixed(round)}KB';
    }

    if (size0 < divider * divider * divider && size0 % divider == 0) {
      return '${(size0 / (divider * divider)).toStringAsFixed(0)}MB';
    }

    if (size0 < divider * divider * divider) {
      return '${(size0 / divider / divider).toStringAsFixed(round)}MB';
    }

    if (size0 < divider * divider * divider * divider && size0 % divider == 0) {
      return '${(size0 / (divider * divider * divider)).toStringAsFixed(0)}GB';
    }

    if (size0 < divider * divider * divider * divider) {
      return '${(size0 / divider / divider / divider).toStringAsFixed(round)}GB';
    }

    if (size0 < divider * divider * divider * divider * divider &&
        size0 % divider == 0) {
      num r = size0 / divider / divider / divider / divider;
      return '${r.toStringAsFixed(0)}TB';
    }

    if (size0 < divider * divider * divider * divider * divider) {
      num r = size0 / divider / divider / divider / divider;
      return '${r.toStringAsFixed(round)}TB';
    }

    if (size0 < divider * divider * divider * divider * divider * divider &&
        size0 % divider == 0) {
      num r = size0 / divider / divider / divider / divider / divider;
      return '${r.toStringAsFixed(0)}PB';
    } else {
      num r = size0 / divider / divider / divider / divider / divider;
      return '${r.toStringAsFixed(round)}PB';
    }
  }

  int doubleHourToMilliseconds(double hour) {
    var a = hour * 60;
    return (a * 60000).toInt();
  }

  double millisecondsToDoubleHour(int milliseconds) {
    var a = milliseconds / 60000;
    return a / 60;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return to.difference(from).inDays;
  }

  String anonymizeCPF(String cpf) {
    final cpfS = cpf.split(".");
    return "${cpfS[0]}.***.***-${cpfS[cpfS.length - 1].split("-").last}";
  }

  double dynamicToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String && value.isNotEmpty) {
      return double.parse(value.replaceAll(".", "").replaceAll(",", "."));
    } else if (value == null || value == "") {
      return 0;
    }
    return value;
  }

  double toDoublePrecision(double value, {int precision = 2}) {
    return double.parse(value.toStringAsFixed(precision));
  }

  double? dynamicToDoubleNullable(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.parse(value);
    }
    return value;
  }

  String removeAccents(String text) {
    final mapAccents = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
    };
    var textWithOutAccents = text;
    for (var map in mapAccents.entries) {
      textWithOutAccents = textWithOutAccents.replaceAll(map.key, map.value);
    }
    return textWithOutAccents;
  }

  MaterialColor materialColorFrom(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);

  String formatDuration(Duration duration) {
    String hours = (duration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return "${hours != "00" ? "$hours:" : ""}$minutes:$seconds";
  }

  String formatInputedDirectory(String dir) {
    var lst = dir[dir.length - 1];
    if (lst == "/") {
      return dir.substring(0, dir.length - 1);
    }
    return dir;
  }

  String removeSpecialCharacters(String text) {
    final regex = RegExp(r'[^\w\s$]', unicode: true, multiLine: true);
    return text.replaceAll(regex, '');
  }

  String getSymbolName(Symbol symbol) {
    return removeSpecialCharacters(symbol.toString().replaceAll("Symbol", ""));
  }

  String getInjectInstanceName<T extends Object>({T? input}) {
    if (input is Function) {
      return input.runtimeType.toString().replaceAll("() => ", "");
    }

    return T.toString();
  }

  String obfuscateName(String name) {
    final split = name.split(' ');
    if (name.length <= 2) {
      return name; // Não obfusca palavras muito curtas
    }
    return split.map((word) {
      if (split.first == word || split.last == word) {
        final isFirst = split.first == word;
        if (name.length > 10) {
          final w =
              isFirst ? word.substring(0, 2) : word.substring(word.length - 2);
          final obfuscated = '*' * (word.length - 2);
          return isFirst ? '$w$obfuscated' : '$obfuscated$w';
        } else {
          final w =
              isFirst ? word.substring(0, 1) : word.substring(word.length - 1);
          final obfuscated = '*' * (word.length - 1);
          return isFirst ? '$w$obfuscated' : '$obfuscated$w';
        }
      } else {
        return '*' * (word.length);
      }
    }).join(' ');
  }

  Color generateHighlightColor(Color tColor) {
    if (ThemeData.estimateBrightnessForColor(tColor) == Brightness.dark) {
      return const Color(0xFFF6F6F8);
    }
    return const Color(0xFF1A191B);
  }

  Color generateHighlightHarmonicColor(Color tColor) {
    var hslColor = HSLColor.fromColor(tColor);

    double adjustedSaturation = hslColor.saturation - 0.2;

    double adjustedLightness = hslColor.lightness > 0.5
        ? hslColor.lightness - 0.2
        : hslColor.lightness + 0.2;

    if (adjustedLightness > 1) {
      adjustedLightness = 1;
    } else if (adjustedLightness < 0) {
      adjustedLightness = 0;
    }

    if (adjustedSaturation > 1) {
      adjustedSaturation = 1;
    } else if (adjustedSaturation < 0) {
      adjustedSaturation = 0;
    }

    var highlightHslColor = HSLColor.fromAHSL(
        1, hslColor.hue, adjustedSaturation, adjustedLightness);

    return highlightHslColor.toColor();
  }

  String brDatetime2IsoDatetime(
    String brDate, {
    String timePreposition = " ",
  }) {
    var split1 = brDate.split(" ");
    String date = "";
    String time = "${timePreposition}00:00:00Z";
    if (split1.length > 1) {
      date = split1[0];
      time = timePreposition + split1[1].substring(0, 5);
    } else {
      date = brDate;
    }
    var split2 = date.split("/");
    if (split2.length == 3) {
      var result = "${split2[2]}-${split2[1]}-${split2[0]}$time";
      return result;
    } else {
      return "";
    }
  }

  String capitalizeFirstWord(String str) {
    if (str.length <= 1) return str.toUpperCase();
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  String capitalizeAllWords(String text) {
    return text
        .trim()
        .split(" ")
        .map((e) => capitalizeFirstWord(e))
        .toList()
        .join(" ");
  }

  String longName2ShortName(String name, {bool withCrop = false}) {
    var splited = name.trim().replaceAll("  ", "").split(" ");
    return splited.length > 1
        ? withCrop
            ? stringCrop("${splited.first} ${splited.last}", 15)
            : "${splited.first} ${splited.last}"
        : name;
  }

  DateTime resetTimeToMidnight(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }

  bool isNumeric(Object value) {
    final text = value.toString().replaceAll(".", "").replaceAll(",", ".");
    if (int.tryParse(text) != null || double.tryParse(text) != null) {
      return value is num;
    }
    return false;
  }

  List<String> get brStates => [
        "AC",
        "AL",
        "AP",
        "AM",
        "BA",
        "CE",
        "DF",
        "ES",
        "GO",
        "MA",
        "MT",
        "MS",
        "MG",
        "PA",
        "PB",
        "PR",
        "PE",
        "PI",
        "RJ",
        "RN",
        "RS",
        "RO",
        "RR",
        "SC",
        "SP",
        "SE",
        "TO",
      ];
}
