class MdCardDetecetor {
  static String dectectCardBrand(String cardNumber) {
    String brand = "";
    numberPatterns.forEach(
      (Brand type, Set<List<String>> patterns) {
        for (List<String> range in patterns) {
          String ccStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = range[0].length;
          if (rangeLen < cardNumber.length) {
            ccStr = ccStr.substring(0, rangeLen);
          }

          if (range.length > 1) {
            final int ccPrefixAsInt = int.parse(ccStr);
            final int startPatternPrefixAsInt = int.parse(range[0]);
            final int endPatternPrefixAsInt = int.parse(range[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              brand = type.toShort;
              break;
            }
          } else {
            if (ccStr == range[0]) {
              brand = type.toShort;
              break;
            }
          }
        }
      },
    );

    return brand;
  }
}

Map<Brand, Set<List<String>>> numberPatterns = <Brand, Set<List<String>>>{
  Brand.visa: <List<String>>{
    <String>['4'],
  },
  Brand.americanExpress: <List<String>>{
    <String>['34'],
    <String>['37'],
  },
  Brand.discover: <List<String>>{
    <String>['6011'],
    <String>['622126', '622925'],
    <String>['644', '649'],
    <String>['65']
  },
  Brand.mastercard: <List<String>>{
    <String>['51', '55'],
    <String>['2221', '2229'],
    <String>['223', '229'],
    <String>['23', '26'],
    <String>['270', '271'],
    <String>['2720'],
  },
};

enum Brand {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}

extension ParseCardType on Brand {
  String get toShort => toString().split(".").last;
}
