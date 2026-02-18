import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  Future<void> initialize() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _controller?.initialize();
  }

  Future<XFile?> takePicture() async {
    return await _controller?.takePicture();
  }
}