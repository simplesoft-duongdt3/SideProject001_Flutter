import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/screen/HistoryScreen.dart';
import 'package:flutter_app/presentation/screen/ShareQrScreen.dart';
import 'package:flutter_app/presentation/screen/SignInScreen.dart';
import 'package:flutter_app/presentation/screen/SignUpScreen.dart';
import 'package:flutter_app/presentation/screen/SplashScreen.dart';
import 'package:flutter_app/presentation/screen/TodayTodosScreen.dart';
import 'package:flutter_app/presentation/screen/add_task/AddTaskScreen.dart';
import 'package:flutter_app/presentation/screen/task/TaskScreen.dart';
import 'package:flutter_app/presentation/screen/task_detail/DailyTaskDetailScreen.dart';
import 'package:flutter_app/presentation/screen/task_detail/OneTimeTaskDetailScreen.dart';

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

  MaterialPageRoute getAddTaskScreen(AddTaskScreenTabSelect tabSelect) {
    return MaterialPageRoute(builder: (context) => AddTaskScreen(tabSelect));
  }

  MaterialPageRoute getDailyTaskDetailScreen(String taskId) {
    return MaterialPageRoute(builder: (context) => DailyTaskDetailScreen(taskId));
  }

  MaterialPageRoute getOneTimeTaskDetailScreen(String taskId) {
    return MaterialPageRoute(builder: (context) => OneTimeTaskDetailScreen(taskId));
  }
}
