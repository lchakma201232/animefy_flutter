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
import 'package:exif/exif.dart';
import '../helpers/auth_functions.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomeScreen({Key? key, required this.cameras}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late String? _imagePath = null;
  late User _user;
  bool _imageLoading = false;
  bool _isCameraFront = false;
  @override
  void initState() {
    super.initState();
    _getAuth();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium,
        enableAudio: false);
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
    if (_isCameraFront) {
      _controller = CameraController(
        _controller.description,
        ResolutionPreset.medium,
        enableAudio: false,
      );
    } else {
      _controller = CameraController(
        widget.cameras[1],
        ResolutionPreset.medium,
        enableAudio: false,
      );
    }
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraFront = !_isCameraFront;
      });
    });
  }

  _capture() async {
    XFile path = await _controller.takePicture();
    // print(path.path);
    setState(() {
      _imagePath = path.path;
      _imageLoading = true;
    });
    print('mehere');
    try {
      final credit = await checkCredit(_user);
      if (credit < 1) {
        _showCreditAlert();
        setState(() {
          _imageLoading = false;
        });
        return;
      }
      var image = File(path.path);
      var exifdata = await readExifFromBytes(await image.readAsBytes());
      // print(exifdata['Image Orientation']);
      image = await FlutterNativeImage.compressImage(_imagePath!, quality: 100);
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

  _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
  }

  _checkCredit(User user) async {}

  @override
  Widget build(BuildContext context) {
    // // print('Building Home Screen');
    if (_controller == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
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
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        color: Colors.black,
                        child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Center(
                                child: _imageLoading
                                    ? Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : _imagePath == null
                                        ? CameraPreview(_controller,
                                            child: Stack(
                                              children: <Widget>[
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons
                                                                  .flip_camera_android,
                                                              color:
                                                                  Colors.white),
                                                          onPressed:
                                                              _toggleCameraType,
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: _capture,
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _imagePath =
                                                                    null;
                                                              });
                                                            },
                                                            icon: Icon(
                                                                Icons.refresh,
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                        : Image.file(
                                            File(_imagePath!),
                                            fit: BoxFit.contain,
                                          )))),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _imagePath == null
                        ? Container()
                        : Container(
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.flip_camera_android,
                                      color: Colors.white),
                                  onPressed: _toggleCameraType,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.camera_alt,
                                      color: Colors.white),
                                  onPressed: _capture,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _imagePath = null;
                                      });
                                    },
                                    icon: Icon(Icons.refresh,
                                        color: Colors.white))
                              ],
                            ),
                          ),
                  ),
                ],
              );
            } else {
              return Container(
                // decoration: BoxDecoration(
                //   color: Colors.black,
                // ),
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }
}
