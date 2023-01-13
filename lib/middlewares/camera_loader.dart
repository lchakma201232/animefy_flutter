import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project/screens/home_screen.dart';

class HomeScreenMiddleware extends StatefulWidget {
  HomeScreenMiddleware({super.key});

  @override
  State<HomeScreenMiddleware> createState() => _HomeScreenWidget();
}

class _HomeScreenWidget extends State<HomeScreenMiddleware> {
  List<CameraDescription>? cameras;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(cameras: cameras!);
  }
}
