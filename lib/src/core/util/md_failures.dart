abstract class MdFailure implements Exception {
  MdFailure(this.message);
  final String message;
}

class MdHttpDriverServerFailure extends MdFailure {
  MdHttpDriverServerFailure({String message = "", int? statusCode})
      : super(
          "${statusCode != null ? "HttpCode: $statusCode | ExceptionMessage: " : "Exception message: "}$message",
        );
}

class MdHttpDriverGenericFailure extends MdFailure {
  final Map<String, dynamic> data;
  final int httpCode;

  MdHttpDriverGenericFailure({
    String message = "",
    required this.data,
    required this.httpCode,
  }) : super(message);

  @override
  String toString() =>
      'MdHttpDriverGenericFailure(data: $data, httpCode: $httpCode)';
}

class MdHttpDriverServerBadResponseFailure extends MdFailure {
  final String code;
  final int statusCode;
  final dynamic data;

  MdHttpDriverServerBadResponseFailure({
    required String message,
    required this.code,
    required this.data,
    required this.statusCode,
  }) : super(message);

  @override
  String toString() =>
      'MdHttpDriverServerBadResponseFailure(code: $code, statusCode: $statusCode, data: $data)';
}
