import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = '', password = '', confirmPassword = '';
  bool emptyEmail = false;
  bool emptyPassword = false;
  bool emptyConfirmPassword = false;
  bool passwordMismatch = false;
  bool isLoading = false;

  void _signUp() async {
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
    if (confirmPassword.isEmpty) {
      setState(() {
        emptyConfirmPassword = true;
      });
    }
    if (password != confirmPassword) {
      setState(() {
        passwordMismatch = true;
      });
    }
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword) {
      setState(() {
        emptyEmail = false;
        emptyPassword = false;
        emptyConfirmPassword = false;
        passwordMismatch = false;
      });
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } catch (e) {
        setState(() {
          emptyEmail = true;
          emptyPassword = true;
          emptyConfirmPassword = true;
          passwordMismatch = true;
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
                child: Column(
                  children: [
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
                    TextField(
                      obscureText: true,
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
                    ),
                    TextField(
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          errorText: emptyConfirmPassword
                              ? 'Confirm Password can\'t be empty'
                              : passwordMismatch
                                  ? 'Passwords do not match'
                                  : null,
                          labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    isLoading
                        ? CircularProgressIndicator()
                        : Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 253, 146, 72),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montser'),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 253, 146, 72),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
