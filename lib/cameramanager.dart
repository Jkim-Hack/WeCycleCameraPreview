import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraManager extends StatefulWidget {
  @override
  _CameraManagerState createState() {
    return _CameraManagerState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

class _CameraManagerState extends State<CameraManager>
    with WidgetsBindingObserver{

  CameraController cameraController;
  String imagePath;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    CameraImage cameraImage;

    return null;
  }

}