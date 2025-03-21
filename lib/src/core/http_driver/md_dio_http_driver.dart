import 'dart:io';

import 'package:dio/dio.dart';
import 'package:md_engine/src/core/util/md_failures.dart';
import 'package:md_engine/src/md_app.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'md_http_driver_interface.dart';

import 'md_http_driver_interceptor.dart';
import 'md_http_driver_response_parser.dart';

typedef _DioFactoryConfig = void Function(Dio dio);

class _DioFactory {
  _DioFactory._intenal();
  static final I = _DioFactory._intenal();

  final _storage = <String, Dio>{};

  Dio getDio(String baseUrl, {required _DioFactoryConfig onConfig}) {
    if (!_storage.containsKey(baseUrl)) {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
        ),
      );
      onConfig(dio);
      _storage[baseUrl] = dio;
    }
    return _storage[baseUrl]!;
  }
}

class MdDioHttpDriver implements IMdHttpDriver {
  String? baseUrl;
  late final Dio dio;
  MdDioHttpDriver({this.baseUrl, List<Interceptor> interceptors = const []}) {
    dio = _DioFactory.I.getDio(
      baseUrl ?? MdApp.I.httpDriverOptions.baseUrl(),
      onConfig: (dio) {
        dio.options.headers.addAll(
          {
            'content-type': "application/json; charset=utf-8",
          },
        );
        dio.interceptors.addAll(
          [
            ...interceptors,
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
                filter: (options, args) {
                  return _enableLog;
                },
              )
          ],
        );
      },
    );
  }
  bool _enableLog = true;

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
    String mineType = 'image/png',
  }) async {
    _enableLog = false;
    dio.options.headers['content-type'] = mineType;
    return await interceptRequests(
      dio.get(
        path,
        queryParameters: queryParameters,
        options: options?.copyWith(
              responseType: ResponseType.bytes,
            ) ??
            Options(responseType: ResponseType.bytes),
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
    _enableLog = true;
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
