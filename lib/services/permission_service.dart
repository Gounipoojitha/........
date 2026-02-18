import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.location, Permission.microphone].request();
  }
}