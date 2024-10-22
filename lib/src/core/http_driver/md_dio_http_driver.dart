import 'dart:io';

import 'package:dio/dio.dart';
import 'package:md_engine/src/core/util/md_failures.dart';
import 'package:md_engine/src/md_app.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'md_http_driver_interface.dart';

import 'md_http_driver_interceptor.dart';
import 'md_http_driver_response_parser.dart';

class _DioFactory {
  static Dio? _dio;
  static Dio get instance {
    _dio ??= Dio();
    return _dio!;
  }
}

class MdDioHttpDriver implements IMdHttpDriver {
  String? baseUrl;
  MdDioHttpDriver({
    this.baseUrl,
  }) {
    _setConfig();
  }

  Dio get dio => _DioFactory.instance;

  void _setConfig() {
    dio.options.baseUrl = baseUrl ?? MdApp.I.httpDriverOptions.baseUrl();
    dio.options.headers.addAll(
      {
        'content-type': "application/json; charset=utf-8",
      },
    );
    dio.interceptors.addAll(
      [
        MdHttpDriverInterceptor(dio),
        MdApp.I.httpDriverOptions.middleware..setHttpDriver(this),
        if (MdApp.I.httpDriverOptions.enableLogger)
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          )
      ],
    );
  }

  @override
  Future<MdHttpDriverResponse> interceptRequests(Future request) async {
    try {
      var response = await request.catchError((e) => throw e);
      return MdApp.I.httpDriverOptions.responseParser.success(response);
    } on DioException catch (e) {
      Exception error = e;
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.error is SocketException) {
        error = MdHttpDriverNetworkFailure(message: e.message ?? "");
      }

      return MdApp.I.httpDriverOptions.responseParser.error(error);
    }
  }

  @override
  Future<MdHttpDriverResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.get(
        path,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      ),
    );
  }

  @override
  Future<MdHttpDriverResponse> getFile<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    dio.options.headers['content-type'] = 'image/png';
    return await interceptRequests(
      dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  @override
  Future<MdHttpDriverResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      ),
    );
  }

  @override
  Future<MdHttpDriverResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      ),
    );
  }

  @override
  Future<MdHttpDriverResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      ),
    );
  }

  @override
  Future<MdHttpDriverResponse> delete<T>(
    String path, {
    dynamic data,
    String? key,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    resetContentType();
    return await interceptRequests(
      dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  @override
  void resetContentType() {
    dio.options.headers['content-type'] = 'application/json; charset=utf-8';
  }

  @override
  Future<MdHttpDriverResponse> sendFile<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HttpDriverProgressCallback? onReceiveProgress,
    HttpDriverProgressCallback? onSendProgress,
  }) async {
    dio.options.headers['content-type'] = 'multipart/form-data';
    return await interceptRequests(
      dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      ),
    );
  }
}
