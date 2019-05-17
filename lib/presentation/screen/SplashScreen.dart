import 'package:flutter/material.dart';
import 'package:flutter_app/data/FirebaseController.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  final FireAuthController _fireAuthController = diResolver.resolve();

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
          image: AssetImage('assets/images/logo_tiny_task.png'),
          width: 240,
          height: 240,
        ),
      ),
    );
  }

  void _navigatorToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isLogin = await _fireAuthController.isLogin();
    if (isLogin) {
      Navigator.of(context).pushReplacementNamed("/main");
    } else {
      Navigator.of(context).pushReplacementNamed("/signin");
    }
  }
}
