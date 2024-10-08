import 'package:dio/dio.dart';
import 'md_http_driver_interface.dart';

abstract class MdHttpDriverMiddleware extends Interceptor {
  IMdHttpDriver? httpDriver;
  void setHttpDriver(IMdHttpDriver httpDriver) {
    this.httpDriver = httpDriver;
  }
}

final class MdDefaultHttpDriverMiddleware extends MdHttpDriverMiddleware {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }
}
