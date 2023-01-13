import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../helpers/helper_functions.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<String> images = [];
  int _currentIndex = 0;
  bool _isOpen = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        loadImages(user).then((res) {
          setState(() {
            images = res;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (images.length == 0) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(images[index])),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
              );
            },
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(),
            ),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: _currentIndex),
            enableRotation: true,
          ),
        ],
      ),
    );
  }
}
