import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/middlewares/camera_loader.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/screens/image_gallery.dart';
import 'package:flutter_project/screens/signup_screen.dart';
import 'package:flutter_project/screens/login_screen.dart';
import 'package:flutter_project/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
        routes: {
          '/home': (context) => HomeScreenMiddleware(),
          '/login': (context) => LoginScreen(),
          '/welcome': (context) => WelcomeScreen(),
          '/signup': (context) => SignUpScreen(),
          '/ImageGallery': (context) => Gallery(),
        });
  }
}
