import 'package:dio/dio.dart';

import '../../md_app.dart';
import '../util/md_toolkit.dart';
import 'md_http_driver_options.dart';

class MdHttpDriverInterceptor extends Interceptor {
  final Dio dio;
  MdHttpDriverOptions get httpDriverOptions => MdApp.I.httpDriverOptions;

  MdHttpDriverInterceptor(this.dio);
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var apiKey = httpDriverOptions.apiKey(
      key: options.extra["key"] ?? "",
    );
    var accessTokenType = httpDriverOptions.accessTokenType?.call(
      key: options.extra["key"] ?? "",
    );
    options.extra.remove("key");
    if (options.baseUrl.contains(options.uri.host)) {
      var token = await httpDriverOptions.accessToken();
      var uToken = await httpDriverOptions.uToken();
      if (token.isEmpty) {
        if (options.headers.containsKey("Authorization")) {
          options.headers.remove("Authorization");
        }
      } else {
        options.headers["Authorization"] = '$accessTokenType $token';
      }
      if (uToken.isNotEmpty) {
        options.headers["X-UTOKEN"] = uToken;
      }
      if (httpDriverOptions.deviceId != null) {
        options.headers["X-DEVICE-ID"] = httpDriverOptions.deviceId;
      }
      if (httpDriverOptions.buildNumber != null) {
        options.headers["X-BUILD-NUMBER"] = httpDriverOptions.buildNumber;
      }
      if (httpDriverOptions.appName != null) {
        options.headers["X-APP-NAME"] =
            MdToolkit.I.removeAccents(httpDriverOptions.appName ?? "");
      }
      if (httpDriverOptions.appVersion != null) {
        options.headers["X-APP-VERSION"] = httpDriverOptions.appVersion;
      }
      if (httpDriverOptions.packageName != null) {
        options.headers["X-PACKAGE-NAME"] = httpDriverOptions.packageName;
      }
      if (httpDriverOptions.buildSignature != null) {
        options.headers["X-BUILD-SIGNATURE"] = httpDriverOptions.buildSignature;
      }
      if (httpDriverOptions.service != null) {
        options.headers["X-SERVICE"] = httpDriverOptions.service;
      }
      if (httpDriverOptions.locationCode != null) {
        options.headers["X-LANG"] = httpDriverOptions.locationCode;
      }
      if (httpDriverOptions.apiKey().isNotEmpty) {
        options.headers["X-API-KEY"] = apiKey;
      }
    } else if (apiKey.isNotEmpty) {
      if (options.headers.containsKey("Authorization")) {
        options.headers.remove("Authorization");
      }
      options.headers["Authorization"] = '$accessTokenType $apiKey';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future onError(DioException error, ErrorInterceptorHandler handler) async {
    return super.onError(error, handler);
  }
}
