import '../http_driver/md_http_driver_interface.dart';

abstract class MdService {
  final IMdHttpDriver httpDriver;
  MdService({required this.httpDriver});
}
