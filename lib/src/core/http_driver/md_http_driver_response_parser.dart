import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../util/md_failures.dart';

abstract base class MdBaseHttpDriverResponseParser {
  MdHttpDriverResponse noNetwork(MdHttpDriverResponse response) {
    return response;
  }

  MdHttpDriverResponse range100(MdHttpDriverResponse response) {
    return response;
  }

  MdHttpDriverResponse range200(MdHttpDriverResponse response) {
    return response;
  }

  MdHttpDriverResponse range300(MdHttpDriverResponse response) {
    return response;
  }

  MdHttpDriverResponse range400(MdHttpDriverResponse response);
  MdHttpDriverResponse range500(MdHttpDriverResponse response);

  @mustCallSuper
  MdHttpDriverResponse success(dynamic response) {
    return range200(
      MdHttpDriverResponse(
        data: response.data,
        statusCode: response.statusCode,
        message: "",
      ),
    );
  }

  @mustCallSuper
  MdHttpDriverResponse error(Exception error) {
    if (error is DioException) {
      var errorReponse = MdHttpDriverResponse(
        message: error.message ?? "",
        statusCode: error.response?.statusCode ?? 400,
        data: error.response?.data,
      );
      switch (error.response!.statusCode ?? 500) {
        case >= 300 && < 400:
          return range300(errorReponse);
        case >= 400 && < 500:
          return range400(errorReponse);
        case >= 500 && < 512:
        default:
          return range500(
            MdHttpDriverResponse(
              message: error.message ?? "",
              statusCode: error.response?.statusCode ?? 400,
              data: error.response?.data,
            ),
          );
      }
    } else if (error is MdHttpDriverNetworkFailure) {
      return noNetwork(
        MdHttpDriverResponse(
          message: error.message,
          statusCode: 0,
          failure: error,
        ),
      );
    } else {
      return range200(
        MdHttpDriverResponse(
          statusCode: 500,
          message: error.toString(),
        ),
      );
    }
  }
}

final class MdDefaultHttpDriverResponseParser
    extends MdBaseHttpDriverResponseParser {
  @override
  MdHttpDriverResponse range200(MdHttpDriverResponse response) {
    return response;
  }

  @override
  MdHttpDriverResponse range400(MdHttpDriverResponse response) {
    return response;
  }

  @override
  MdHttpDriverResponse range500(MdHttpDriverResponse response) {
    return response;
  }
}

class MdHttpDriverResponse {
  final dynamic data;
  String code;
  final String message;
  final int statusCode;
  late final MdFailure? _failure;

  MdHttpDriverResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.code = "",
    MdFailure? failure,
  }) {
    _failure = failure;
  }

  bool get isSuccess =>
      statusCode == 200 || statusCode == 201 || statusCode == 204;

  Object makeFailure() {
    if (_failure != null) {
      return _failure;
    } else {
      if (statusCode >= 400 && statusCode < 500) {
        return MdHttpDriverServerBadResponseFailure(
          message: message,
          code: code,
          data: data,
          statusCode: statusCode,
        );
      } else {
        return MdHttpDriverServerFailure(
          statusCode: statusCode,
          message: message,
        );
      }
    }
  }

  MdHttpDriverResponse copyWith({
    String? message,
    dynamic data,
    String? code,
    MdFailure? failure,
  }) {
    return MdHttpDriverResponse(
      data: data ?? this.data,
      code: code ?? this.code,
      failure: failure ?? _failure,
      statusCode: statusCode,
      message: message ?? this.message,
    );
  }
}
