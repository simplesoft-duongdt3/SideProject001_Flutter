import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/screen/AddEventScreen.dart';
import 'package:flutter_app/presentation/screen/HistoryScreen.dart';
import 'package:flutter_app/presentation/screen/MainScreen.dart';
import 'package:flutter_app/presentation/screen/SignInScreen.dart';
import 'package:flutter_app/presentation/screen/SignUpScreen.dart';
import 'package:flutter_app/presentation/screen/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/main": (context) => MainScreen(),
        "/add_event": (context) => AddEventScreen(),
        "/task_history": (context) => HistoryScreen(),
        "/signup": (context) => SignUpScreen(),
        "/signin": (context) => SignInScreen(),
      },
    );
  }
}