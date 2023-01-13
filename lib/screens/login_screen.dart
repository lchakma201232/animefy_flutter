import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:animefy/components/Loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  bool emptyEmail = false;
  bool emptyPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });
    if (email.isEmpty) {
      setState(() {
        emptyEmail = true;
      });
    }
    if (password.isEmpty) {
      setState(() {
        emptyPassword = true;
      });
    }
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        emptyEmail = false;
        emptyPassword = false;
      });
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        // ignore: unnecessary_null_comparison
        if (user != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        setState(() {
          emptyEmail = true;
          emptyPassword = true;
        });
        print(e);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 61, 167, 148),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 150,
                ),
                Image.asset(
                  'assets/images/small_logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 40, right: 40, bottom: 20),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  // color: Colors.white,
                  child: Column(children: [
                    const Text(
                      'Animefy',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Rockybilly',
                          color: Color.fromARGB(255, 46, 125, 111)),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          errorText:
                              emptyEmail ? 'Email can\'t be empty' : null,
                          labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Password',
                          errorText:
                              emptyPassword ? 'Password can\'t be empty' : null,
                          labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          )),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 253, 146, 72),
                            borderRadius: BorderRadius.circular(30)),
                        child: ElevatedButton(
                            onPressed: _login,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(255, 253, 146, 72)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ))),
                            child: const Text("Login"))),
                    const SizedBox(
                      height: 20,
                    ),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/signup');
                              },
                              child: const Text('SignUp',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 253, 146, 72),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline))),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
