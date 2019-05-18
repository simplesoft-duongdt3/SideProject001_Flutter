import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/PresentationDependencyInjectRegister.dart';
import 'package:flutter_app/presentation/screen/AddEventScreen.dart';
import 'package:flutter_app/presentation/screen/HistoryScreen.dart';
import 'package:flutter_app/presentation/screen/TaskScreen.dart';
import 'package:flutter_app/presentation/screen/TodayTodosScreen.dart';
import 'package:flutter_app/presentation/screen/ShareQrScreen.dart';
import 'package:flutter_app/presentation/screen/SignInScreen.dart';
import 'package:flutter_app/presentation/screen/SignUpScreen.dart';
import 'package:flutter_app/presentation/screen/SplashScreen.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'data/DataDependencyInjectRegister.dart';

final kiwi.Container diResolver = kiwi.Container();
void main() async {
  setupDi();
  runApp(MyApp());
}

void setupDi() async {
  var diRegisters = [
    DataDependencyInjectRegister(),
    PresentationDependencyInjectRegister()
  ];
  for (var di in diRegisters) {
    await di.register(diResolver);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiny Task',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/today_todos": (context) => TodayTodosScreen(),
        "/add_task": (context) => AddEventScreen(),
        "/task_history": (context) => HistoryScreen(),
        "/signup": (context) => SignUpScreen(),
        "/signin": (context) => SignInScreen(),
        "/share_qr_code": (context) => ShareQrScreen(),
        "/tasks": (context) => TaskScreen(),
      },
    );
  }
}
