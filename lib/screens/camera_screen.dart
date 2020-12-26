import 'dart:io';
import 'package:ecosorter/screens/classification.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  List<CameraDescription> cameras;
  var loading;
  @override
  void initState() {
    super.initState();
    loading = true;
    availableCameras().then((value) {
      cameras = value;
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file = File(
              '${(await getTemporaryDirectory()).path}/${randomString(10)}');

          controller.takePicture(file.path);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Classification(file.path),
            ),
          );
        },
      ),
      body: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: CameraPreview(
          controller,
        ),
      ),
    );
  }
}
