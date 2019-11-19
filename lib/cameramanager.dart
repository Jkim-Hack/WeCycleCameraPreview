import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'CirclePainter.dart';
import 'main.dart';
import 'button_icons_icons.dart';

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

  CameraController controller;
  String imagePath;

  IconButton challengesButton = new IconButton(icon: new Icon(ButtonIcons.ic_star_24px, color: Colors.white, size: 43,), onPressed: null);
  IconButton friendsButton = new IconButton(icon: new Icon(ButtonIcons.ic_people_24px, color: Colors.white, size: 40,), onPressed: null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.veryHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }


  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return Scaffold(
      body: Stack(children: <Widget>[
          _cameraPreviewWidget(),
          snapButton(),
          Row (
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
               Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding( //Challenges button
                      padding: const EdgeInsets.fromLTRB(20,20,20,5),
                      child: challengesButton,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(33,0,20,20),
                      child: Text('Challenges',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding( //Friends button
                      padding: const EdgeInsets.fromLTRB(20,20,40,5),
                      child: friendsButton,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,33,20),
                      child: Text('Friends',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

      ],
      )
  );
  }

  Widget _profileButton(){
    return Align(
      alignment: Alignment.topLeft,
      child: RawMaterialButton(
        onPressed: onSnapButtonPressed,
        shape: CircleBorder().scale(2.0),
        child: CustomPaint(
          painter: CirclePainter(
              color: Colors.white,
              strokeWidth: 5,
              isAntialias: true,
              paintingStyle: PaintingStyle.stroke
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if(controller != null && controller.value.isInitialized){
      final size = MediaQuery.of(context).size;
      final deviceRatio = size.width / size.height;
      return Transform.scale(
        scale: controller.value.aspectRatio / deviceRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
      );
    } else {
      return const Text('Camera not on',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
  }

  Widget snapButton(){
    Alignment alignmentConfig = new Alignment(Alignment.bottomCenter.x, Alignment.bottomCenter.y - .25);
    return Align(
      alignment: alignmentConfig,
      child: RawMaterialButton(
        onPressed: onSnapButtonPressed,
        shape: CircleBorder().scale(2.0),
        child: CustomPaint(
          painter: CirclePainter(
            color: Colors.white,
            strokeWidth: 5,
            isAntialias: true,
            paintingStyle: PaintingStyle.stroke
          ),
        ),
      ),
    );
  }

  void onSnapButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          log(imagePath);
          //controller?.dispose();
          //controller = null;
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => DisplayImageToScreen(imagePath: imagePath),
              )
          );
        });
        if (filePath != null){}
          //showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      //showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      //_showCameraException(e);
      return null;
    }
    return filePath;
  }
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

}

class DisplayImageToScreen extends StatefulWidget{

  static const platform = const MethodChannel('com.teamblnd/imgclassif');
  final String imagePath;
  const DisplayImageToScreen({Key key, this.imagePath}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DisplayedImageScreen();
  }

}

class DisplayedImageScreen extends State<DisplayImageToScreen>{

  String imagePath;

  @override
  void initState() {
    imagePath = widget.imagePath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Image.file(new File(imagePath)),
      fit: BoxFit.fill,
    );
  }

  Widget predictButton(){
    return FloatingActionButton(

    );
  }

  void onPredictButtonPressed(){
    isRecyclableObject(this.imagePath).then((bool value) {
      if(value){
        setState(() {

        });
      }
    });
  }

  Future<bool> isRecyclableObject(String imagePath) async {
    bool isRecyclable = false;
    try{
      isRecyclable = await DisplayImageToScreen.platform.invokeMethod('getClassificationResult',imagePath);
    } on PlatformException catch(e){
      log("Failed!: " + e.message);
    }
    return isRecyclable;
  }
}