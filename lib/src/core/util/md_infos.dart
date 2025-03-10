import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MdInfos {
  static final MdInfos I = MdInfos._internal();
  MdInfos._internal();

  final deviceInfo = DeviceInfoPlugin();
  late final PackageInfo packageInfo;

  late final String deviceId;
  late final String buildNumber;
  late final String appName;
  late final String packageName;
  late final String buildSignature;
  late final String version;

  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      deviceId = (await deviceInfo.iosInfo).identifierForVendor ?? "";
    } else {
      deviceId = (await deviceInfo.androidInfo).id;
    }
    buildNumber = packageInfo.buildNumber;
    appName = packageInfo.appName;
    buildSignature = packageInfo.buildSignature;
    version = packageInfo.version;
    packageName = packageInfo.packageName;
  }
}
