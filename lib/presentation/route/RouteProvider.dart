import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/screen/AddTaskScreen.dart';
import 'package:flutter_app/presentation/screen/HistoryScreen.dart';
import 'package:flutter_app/presentation/screen/ShareQrScreen.dart';
import 'package:flutter_app/presentation/screen/SignInScreen.dart';
import 'package:flutter_app/presentation/screen/SignUpScreen.dart';
import 'package:flutter_app/presentation/screen/SplashScreen.dart';
import 'package:flutter_app/presentation/screen/TaskDetailScreen.dart';
import 'package:flutter_app/presentation/screen/TaskScreen.dart';
import 'package:flutter_app/presentation/screen/TodayTodosScreen.dart';

class RouterProvider {
  MaterialPageRoute getSplashScreen() {
    return MaterialPageRoute(builder: (context) => SplashScreen());
  }

  MaterialPageRoute getTodayTodosScreen() {
    return MaterialPageRoute(builder: (context) => TodayTodosScreen());
  }

  MaterialPageRoute getHistoryScreen() {
    return MaterialPageRoute(builder: (context) => HistoryScreen());
  }

  MaterialPageRoute getSignUpScreen() {
    return MaterialPageRoute(builder: (context) => SignUpScreen());
  }

  MaterialPageRoute getSignInScreen() {
    return MaterialPageRoute(builder: (context) => SignInScreen());
  }

  MaterialPageRoute getShareQrScreen() {
    return MaterialPageRoute(builder: (context) => ShareQrScreen());
  }

  MaterialPageRoute getTaskScreen() {
    return MaterialPageRoute(builder: (context) => TaskScreen());
  }

  MaterialPageRoute getAddTaskScreen() {
    return MaterialPageRoute(builder: (context) => AddTaskScreen());
  }

  MaterialPageRoute getTaskDetailScreen(String taskId) {
    return MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId));
  }
}
