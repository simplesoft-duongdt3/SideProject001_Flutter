import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/AddTaskScreenBloc.dart';
import 'package:flutter_app/presentation/screen/add_task/AddDailyTaskScreen.dart';
import 'package:flutter_app/presentation/screen/add_task/AddOneTimeTaskScreen.dart';

class AddTaskScreen extends StatefulWidget {
  final AddTaskScreenTabSelect _selectedTab;

  AddTaskScreen(this._selectedTab, {Key key}) : super(key: key);

  @override
  _AddTaskScreenState createState() {
    return _AddTaskScreenState("Add tasks", _selectedTab);
  }
}

enum AddTaskScreenTabSelect { DAILY, ONE_TIME }

class _AddTaskScreenState extends State<AddTaskScreen> {
  final AddTaskScreenTabSelect _selectedTab;
  final String _title;
  final AddTaskScreenBloc addTaskScreenBloc = diResolver.resolve();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  _AddTaskScreenState(this._title, this._selectedTab);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: getInitTabIndex(),
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

  int getInitTabIndex() {
    if (_selectedTab == AddTaskScreenTabSelect.DAILY) {
      return 0;
    } else {
      return 1;
    }
  }
}
