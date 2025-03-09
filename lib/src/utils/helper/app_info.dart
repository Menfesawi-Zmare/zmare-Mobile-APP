import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  static Future<String> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static bool isNewVersionAvailable(String localVersion, String latestVersion) {
    List<int> localParts = localVersion.split('.').map(int.parse).toList();
    List<int> latestParts = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= localParts.length) return true;
      if (latestParts[i] > localParts[i]) return true;
      if (latestParts[i] < localParts[i]) return false;
    }
    return false;
  }
}
