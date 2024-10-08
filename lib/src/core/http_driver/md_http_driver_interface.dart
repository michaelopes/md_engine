import 'package:dio/dio.dart';

import 'md_http_driver_response_parser.dart';

typedef HttpDriverProgressCallback = void Function(int count, int total);

abstract class IMdHttpDriver {
  Future<dynamic> interceptRequests(Future request);
  Future<MdHttpDriverResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<MdHttpDriverResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<MdHttpDriverResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<MdHttpDriverResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  });

  Future<MdHttpDriverResponse> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<MdHttpDriverResponse> sendFile<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
    HttpDriverProgressCallback? onSendProgress,
  });

  Future<MdHttpDriverResponse> getFile<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  void resetContentType();
}
