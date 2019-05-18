import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/presentation/bloc/TodayTodosScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class TodayTodosScreen extends StatefulWidget {

  TodayTodosScreen({Key key}) : super(key: key);

  @override
  TodayTodosScreenState createState() {
    return TodayTodosScreenState("Todos");
  }
}

class TodayTodosScreenState extends State<TodayTodosScreen> {
  final String _title;
  final TodayTodosScreenBloc _mainScreenBloc = diResolver.resolve();
  bool isLoading = true;
  var timeFormat = new NumberFormat("00", "en_US");
  TodayTodosScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {
              _onTasksClicked();
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              _onHistoryClicked();
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _onShareClicked();
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _onLogoutClicked();
            },
          ),
        ],
      ),
      body: Center(
        child: buildContentWidget(context),
      ),
    );
  }

  Widget buildContentWidget(BuildContext context) {
    return FutureBuilder<List<TodayTodoPresentationModel>>(
      future: _mainScreenBloc.loadEventList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<TodayTodoPresentationModel> eventList = snapshot.data;
              if (eventList.isEmpty) {
                return buildEmptyListWidget();
              } else {
                return buildListWidget(eventList);
              }
            } else {
              return buildErrorWidget();
            }
          }
        }
      },
    );
  }

  InkWell buildErrorWidget() {
    return InkWell(
      child: Text(
        "Something wrong occured here, guys!\nClick here to reload!",
        textAlign: TextAlign.center,
      ),
      onTap: _refreshData,
    );
  }

  CircularProgressIndicator buildLoadingWidget() {
    return CircularProgressIndicator();
  }

  RefreshIndicator buildListWidget(List<TodayTodoPresentationModel> eventList) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.separated(
        itemBuilder: (context, index) =>
            buildListItem(eventList, context, index),
        scrollDirection: Axis.vertical,
        itemCount: eventList.length,
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
            ),
      ),
    );
  }

  Center buildEmptyListWidget() {
    return Center(
      child: InkWell(
        child: Text(
          "You don't have any todo tasks, today!\nClick here to reload!",
          textAlign: TextAlign.center,
        ),
        onTap: _refreshData,
      ),
    );
  }

  Widget buildListItem(
      List<TodayTodoPresentationModel> eventList, BuildContext context, int index) {
    var event = eventList[index];
    return ListTile(
      leading: Icon(
        Icons.event_note,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        event.name,
      ),
      subtitle: Text(
        '${timeFormat.format(event.expiredHour)}:${timeFormat.format(event.expiredMinute)}',
      ),
      trailing: buildStatusWidget(event),
    );
  }

  Widget buildStatusWidget(TodayTodoPresentationModel event) {
    if (event.status == TaskStatus.TODO) {
      return InkWell(
        onTap: () {
          _onDoneTaskClicked(event);
        },
        child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.done,
              color: Colors.green,
              size: 32,
            )),
      );
    } else {
      return null;
    }
  }

  void _onTasksClicked() {
    Navigator.pushNamed(context, '/tasks');
  }

  void _onDoneTaskClicked(TodayTodoPresentationModel event) {
    _showConfirmDoneTaskDialog(event);
  }

  void _showConfirmDoneTaskDialog(TodayTodoPresentationModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Done task?"),
          content:
              new Text("Task will done when you accept this action! Careful!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                //nothing to do
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("DONE"),
              onPressed: () async {
                Navigator.of(context).pop();
                await _mainScreenBloc.doneTask(event.eventId, event.historyId);
                _refreshData();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Logout?"),
          content:
          new Text("Current user will logout when you accept this action! Careful!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                //nothing to do
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("LOGOUT"),
              onPressed: () async {
                await _mainScreenBloc.logout();
                Navigator.of(context).pop();
                _gotoSignInScreen();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  void _onHistoryClicked() {
    Navigator.pushNamed(context, '/task_history');
  }

  void _onLogoutClicked() {
    _showConfirmLogoutDialog();
  }

  void _gotoSignInScreen() {
    Navigator.of(context).pushReplacementNamed('/signin');
  }

  void _onShareClicked() {
    Navigator.of(context).pushNamed('/share_qr_code');
  }
}
