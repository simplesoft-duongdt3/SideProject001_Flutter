import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/AddEventScreen.dart';
import 'package:flutter_app/presentation/MainScreen.dart';

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
        "/": (context) => MainScreen(),
        "/add_event": (context) => AddEventScreen()
      },
    );
  }
}