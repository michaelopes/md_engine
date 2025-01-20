import 'md_http_driver_middleware.dart';
import 'md_http_driver_response_parser.dart';

typedef AccessToken = Future<String> Function();
typedef UToken = Future<String> Function();
typedef CallbackByKey = String Function({dynamic key});

typedef CallbackType<T> = T Function();

final class MdHttpDriverOptions {
  final AccessToken accessToken;
  final UToken uToken;
  final CallbackByKey baseUrl;
  late final CallbackByKey? accessTokenType;
  final CallbackByKey apiKey;
  final String? locationCode;

  final bool enableLogger;
  final String? service;

  final String? deviceId;
  final String? buildNumber;
  final String? appName;
  final String? appVersion;
  final String? packageName;
  final String? buildSignature;
  late final MdHttpDriverMiddleware middleware;
  late final MdBaseHttpDriverResponseParser responseParser;

  MdHttpDriverOptions({
    required this.accessToken,
    required this.uToken,
    required this.baseUrl,
    required this.apiKey,
    this.enableLogger = true,
    this.locationCode,
    this.service,
    this.deviceId,
    this.buildNumber,
    this.appName,
    this.packageName,
    this.buildSignature,
    this.appVersion,
    CallbackByKey? accessTokenType,
    MdHttpDriverMiddleware? middleware,
    MdBaseHttpDriverResponseParser? responseParser,
  }) {
    this.middleware = middleware ?? MdDefaultHttpDriverMiddleware();
    this.responseParser = responseParser ?? MdDefaultHttpDriverResponseParser();
    if (accessTokenType == null) {
      this.accessTokenType = ({key}) => "";
    } else {
      this.accessTokenType = accessTokenType;
    }
  }

  MdHttpDriverOptions copyWith({
    String? deviceId,
    String? buildNumber,
    String? appName,
    String? appVersion,
    String? packageName,
    String? buildSignature,
  }) {
    return MdHttpDriverOptions(
      accessToken: accessToken,
      apiKey: apiKey,
      baseUrl: baseUrl,
      uToken: uToken,
      accessTokenType: accessTokenType,
      enableLogger: enableLogger,
      locationCode: locationCode,
      service: service,
      deviceId: deviceId ?? this.deviceId,
      buildNumber: buildNumber ?? this.buildNumber,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      packageName: packageName ?? this.packageName,
      buildSignature: buildSignature ?? this.buildSignature,
      responseParser: responseParser,
      middleware: middleware,
    );
  }
}
