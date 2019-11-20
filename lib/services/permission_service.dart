import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestPermission(PermissionGroup permission) async {
    var result = await PermissionHandler().requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }

    return false;
  }

  static Future<bool> checkPermissionStatus(PermissionGroup permission) async {
    PermissionStatus result =
        await PermissionHandler().checkPermissionStatus(permission);
    if (result == PermissionStatus.granted) {
      return true;
    }

    return false;
  }
}
