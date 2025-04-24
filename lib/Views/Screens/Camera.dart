import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'ImagePreviewScreen.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    // Lấy danh sách camera có trên thiết bị
    cameras = await availableCameras();

    // Khởi tạo camera sau
    if (cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );

      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _controller!.takePicture();

      // Chuyển hướng sang trang khác với ảnh đã chụp
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(imagePath: photo.path),
        ),
      );
    } catch (e) {
      print('Lỗi khi chụp ảnh: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CameraPreview(_controller!),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: FloatingActionButton(
              onPressed: takePicture,
              backgroundColor: Colors.white,
              child: Icon(Icons.camera_alt, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
