import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_project/helpers/helper_functions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'dart:io';

import '../helpers/auth_functions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late String? _imagePath = null;
  late User _user;
  bool _imageLoading = false;

  @override
  void initState() {
    super.initState();

    _checkPermission();
    _getAuth();
  }

  _checkPermission() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  _getAuth() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  _toggleCameraType() {
    if (_controller.description.lensDirection == CameraLensDirection.back) {
      _controller = CameraController(
        _controller.description,
        ResolutionPreset.medium,
        enableAudio: false,
      );
    } else {
      _controller = CameraController(
        _controller.description,
        ResolutionPreset.medium,
        enableAudio: false,
      );
    }
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  _capture() async {
    XFile path = await _controller.takePicture();
    print(path.path);
    setState(() {
      _imagePath = path.path;
      _imageLoading = true;
    });

    try {
      final credit = await checkCredit(_user);
      // print(credit);
      // print('Here');
      if (credit < 1) {
        _showCreditAlert();
        setState(() {
          _imageLoading = false;
        });
        return;
      }

      final image =
          await FlutterNativeImage.compressImage(_imagePath!, quality: 100);
      final base64 = base64Encode(image.readAsBytesSync());
      var url = "https://akhaliq-animeganv2.hf.space/api/predict";
      String uri = await animefy(base64, url, "version 2", _user);
      print('hello');
      print(_imagePath);
      setState(() {
        _imagePath = uri;
        _imageLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  _showCreditAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Insufficient Credits"),
          content:
              Text("Please purchase more credits to continue using the app."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _checkCredit(User user) async {
    // Do something to check the user's credit, such as making a call to a server
    // For example:
    // var credit = await someService.checkCredit(user.uid);
    // return credit;
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Animefy"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              Navigator.pushNamed(context, "ImageGallery");
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Center(
                        child: _imageLoading
                            ? Text("Loading...")
                            : _imagePath == null
                                ? AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: CameraPreview(_controller),
                                  )
                                : Image.file(File(_imagePath!),
                                    fit: BoxFit.contain)))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _imageLoading
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _capture,
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip_camera_android),
                        onPressed: _toggleCameraType,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
