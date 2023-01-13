import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/animefy_logo.png',
            fit: BoxFit.fitHeight,
            height: 1000,
          ),
          SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Animefy",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontFamily: 'RockyBilly'),
                  ),
                  const SizedBox(height: 400),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      icon: const Icon(Icons.arrow_forward,
                          color: Color.fromARGB(255, 46, 125, 111), size: 50))
                ],
              ))
        ],
      ),
    );
  }
}
