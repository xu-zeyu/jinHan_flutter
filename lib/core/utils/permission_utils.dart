import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  location,
  photo,
  camera,
  notification,
  network,
}

class PermissionUtils {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return _handlePermissionStatus(status, '位置');
  }

  static Future<bool> requestPhotoPermission() async {
    final status = await Permission.photos.request();
    return _handlePermissionStatus(status, '相册');
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return _handlePermissionStatus(status, '相机');
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return _handlePermissionStatus(status, '通知');
  }

  static Future<bool> requestNetworkPermission() async {
    // iOS/Android 没有可通过 permission_handler 主动申请的通用网络权限。
    // iOS 访问局域网地址时，会在 Info.plist 声明完整后由系统首次访问时自动弹窗。
    return true;
  }

  static Future<bool> requestMultiplePermissions(
      List<PermissionType> types) async {
    final Map<Permission, PermissionStatus> statuses = await [
      if (types.contains(PermissionType.location)) Permission.location,
      if (types.contains(PermissionType.photo)) Permission.photos,
      if (types.contains(PermissionType.camera)) Permission.camera,
      if (types.contains(PermissionType.notification)) Permission.notification,
    ].request();

    if (types.contains(PermissionType.network) &&
        !await requestNetworkPermission()) {
      return false;
    }

    bool allGranted = true;
    for (var type in types) {
      if (type == PermissionType.network) {
        continue;
      }
      Permission permission = _getPermissionFromType(type);
      final status = statuses[permission];
      if (status != PermissionStatus.granted &&
          status != PermissionStatus.limited) {
        allGranted = false;
        break;
      }
    }
    return allGranted;
  }

  static Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }

  static Future<bool> checkPhotoPermission() async {
    return await Permission.photos.isGranted;
  }

  static Future<bool> checkCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  static Future<bool> checkNotificationPermission() async {
    return await Permission.notification.isGranted;
  }

  static Future<bool> launchAppSettings() async {
    return await openAppSettings();
  }

  static Permission _getPermissionFromType(PermissionType type) {
    switch (type) {
      case PermissionType.location:
        return Permission.location;
      case PermissionType.photo:
        return Permission.photos;
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.notification:
        return Permission.notification;
      case PermissionType.network:
        throw UnsupportedError('Network permission is managed by the system');
    }
  }

  static bool _handlePermissionStatus(
      PermissionStatus status, String permissionName) {
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.limited:
        return true;
      default:
        return false;
    }
  }

  static Future<void> requestAllCommonPermissions() async {
    await requestMultiplePermissions([
      PermissionType.location,
      PermissionType.photo,
      PermissionType.camera,
      PermissionType.notification,
      PermissionType.network,
    ]);
  }
}
