import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/bloc/SignInScreenBloc.dart';

import '../../main.dart';

class SignInScreen extends StatefulWidget {
  final String title = 'Sign In';

  @override
  State<StatefulWidget> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (BuildContext context) {
        return _GoogleSignInSection();
      }),
    );
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  SignInScreenBloc _signInScreenBloc = diResolver.resolve();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/logo_tiny_task.png'),
              width: 200,
              height: 200,
            ),
            InkWell(
              onTap: () async {
                bool isLoginSuccess =
                    await _signInScreenBloc.signInWithGoogleAccount();
                if (isLoginSuccess) {
                  _goToHomeScreen();
                }
              },
              child: const Image(
                image: AssetImage('assets/images/btn_google_signin.png'),
                width: 200,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToHomeScreen() {
    Navigator.of(context).pushReplacementNamed('/main');
  }
}
