import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/route/RouteProvider.dart';
import 'package:flutter_app/presentation/screen/add_task/AddTaskScreen.dart';
import 'package:flutter_app/presentation/screen/task/DailyTaskScreen.dart';
import 'package:flutter_app/presentation/screen/task/OneTimeTaskScreen.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key}) : super(key: key);

  @override
  TaskScreenState createState() {
    return TaskScreenState("Tasks");
  }
}

class TaskScreenState extends State<TaskScreen> {
  final String _title;
  final RouterProvider _routerProvider = diResolver.resolve();
  bool isLoading = true;
  var timeFormat = new NumberFormat("00", "en_US");

  TaskScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onAddTaskClicked(context);
                },
              ),
            ],
            title: Text(_title),
            bottom: _buildTabs(),
          ),
          body: _createTabViews(context),
        );
      }),
    );
  }

  Widget _createTabViews(BuildContext context) {
    return TabBarView(
      children: [
        DailyTaskScreen(),
        OneTimeTaskScreen(),
      ],
    );
  }

  PreferredSizeWidget _buildTabs() {
    return TabBar(
      tabs: [
        Tab(text: "Daily"),
        Tab(text: "One time"),
      ],
    );
  }

  void _onAddTaskClicked(BuildContext context) {
    var tabIndex = DefaultTabController.of(context).index;
    if (tabIndex == 0) {
      Navigator.push(context,
          _routerProvider.getAddTaskScreen(AddTaskScreenTabSelect.DAILY));
    } else {
      Navigator.push(context,
          _routerProvider.getAddTaskScreen(AddTaskScreenTabSelect.ONE_TIME));
    }
  }
}
