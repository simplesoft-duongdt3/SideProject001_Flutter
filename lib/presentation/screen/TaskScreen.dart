import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/presentation/bloc/TaskScreenBloc.dart';
import 'package:flutter_app/presentation/bloc/TodayTodosScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class TaskScreen extends StatefulWidget {

  TaskScreen({Key key}) : super(key: key);

  @override
  TaskScreenState createState() {
    return TaskScreenState("Tasks");
  }
}

class TaskScreenState extends State<TaskScreen> {
  final String _title;
  final TaskScreenBloc _taskScreenBloc = diResolver.resolve();
  bool isLoading = true;
  var timeFormat = new NumberFormat("00", "en_US");
  TaskScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _onAddTaskClicked();
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
    return FutureBuilder<List<TaskPresentationModel>>(
      future: _taskScreenBloc.loadActiveTaskList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<TaskPresentationModel> eventList = snapshot.data;
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

  RefreshIndicator buildListWidget(List<TaskPresentationModel> eventList) {
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
          "You don't have any tasks!\nClick here to reload!",
          textAlign: TextAlign.center,
        ),
        onTap: _refreshData,
      ),
    );
  }

  Widget buildListItem(
      List<TaskPresentationModel> eventList, BuildContext context, int index) {
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

  Widget buildStatusWidget(TaskPresentationModel event) {
    return InkWell(
      onTap: () {
        _onDisableTaskClicked(event);
      },
      child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            Icons.delete,
            color: Colors.red.shade400,
            size: 32,
          )),
    );
  }

  void _onDisableTaskClicked(TaskPresentationModel event) {
    _showConfirmDisableTaskDialog(event);
  }

  void _showConfirmDisableTaskDialog(TaskPresentationModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remove task?"),
          content:
              new Text("Task will remove when you accept this action! Careful!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                //nothing to do
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("REMOVE"),
              onPressed: () async {
                Navigator.of(context).pop();
                await _taskScreenBloc.removeTask(event.taskId);
                _refreshData();
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

  void _onAddTaskClicked() {
    Navigator.pushNamed(context, '/add_task');
  }
}
