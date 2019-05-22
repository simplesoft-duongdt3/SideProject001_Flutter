import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/bloc/AddTaskScreenBloc.dart';

import '../../main.dart';
import 'AddDailyTaskScreen.dart';
import 'AddOneTimeTaskScreen.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key key}) : super(key: key);

  @override
  _AddTaskScreenState createState() {
    return _AddTaskScreenState("Add tasks");
  }
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final String _title;
  final AddTaskScreenBloc addTaskScreenBloc = diResolver.resolve();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  _AddTaskScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: Text(_title),
          //hide back button
          //automaticallyImplyLeading: false,
          bottom: _buildTabs(),
        ),
        body: _createTabViews(context),
      ),
    );
  }

  Widget _createTabViews(BuildContext context) {
    return TabBarView(
      children: [
        AddDailyTaskScreen(),
        AddOneTimeTaskScreen(),
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
}
