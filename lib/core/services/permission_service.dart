import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<bool> requestCamera();
  Future<bool> requestStorage();
  Future<bool> requestPhotos();
  Future<bool> requestNotification();
  Future<bool> requestLocation();
  Future<bool> checkPermission(Permission permission);
  Future<void> openSettings();
}

@LazySingleton(as: PermissionService)
class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestStorage() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestPhotos() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestNotification() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  @override
  Future<bool> checkPermission(Permission permission) async {
    return (await permission.status).isGranted;
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
