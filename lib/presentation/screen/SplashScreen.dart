import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _navigatorToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image(
            image: AssetImage('assets/images/logo.png')
        ),
      ),
    );
  }

  void _navigatorToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final FirebaseUser currentUser = await _auth.currentUser();
    if (currentUser  == null) {
      Navigator.of(context).pushReplacementNamed("/signin");
    } else {
      Navigator.of(context).pushReplacementNamed("/main");
    }
  }
}