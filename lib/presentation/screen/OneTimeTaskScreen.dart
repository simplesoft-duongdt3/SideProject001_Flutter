import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/bloc/TaskScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:flutter_app/presentation/route/RouteProvider.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class OneTimeTaskScreen extends StatefulWidget {
  OneTimeTaskScreen({Key key}) : super(key: key);

  @override
  OneTimeTaskScreenState createState() {
    return OneTimeTaskScreenState();
  }
}

class OneTimeTaskScreenState extends State<OneTimeTaskScreen> {
  final TaskScreenBloc _taskScreenBloc = diResolver.resolve();
  final RouterProvider _routerProvider = diResolver.resolve();
  bool isLoading = true;
  var timeFormat = new NumberFormat("00", "en_US");

  OneTimeTaskScreenState();

  @override
  Widget build(BuildContext context) {
    return buildContentWidget(context);
  }

  Widget buildContentWidget(BuildContext context) {
    return Center(
      child: FutureBuilder<List<OneTimeTaskPresentationModel>>(
        future: _taskScreenBloc.getActiveOneTimeTaskList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingWidget();
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<OneTimeTaskPresentationModel> eventList = snapshot.data;
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
      ),
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

  RefreshIndicator buildListWidget(
      List<OneTimeTaskPresentationModel> eventList) {
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

  Widget buildListItem(List<OneTimeTaskPresentationModel> eventList,
      BuildContext context, int index) {
    var event = eventList[index];
    return ListTile(
      onTap: () => _goToTaskDetail(context, event),
      leading: Icon(
        Icons.event_note,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        event.name,
      ),
      subtitle: Text(
        '${timeFormat.format(event.expiredDay)}/${timeFormat.format(event.expiredMonth)}/${event.expiredYear} ${timeFormat.format(event.expiredHour)}:${timeFormat.format(event.expiredMinute)}',
      ),
      trailing: buildStatusWidget(event),
    );
  }

  Future _goToTaskDetail(
      BuildContext context, OneTimeTaskPresentationModel event) {
    return Navigator.of(context)
        .push(_routerProvider.getOneTimeTaskDetailScreen(event.taskId));
  }

  Widget buildStatusWidget(OneTimeTaskPresentationModel event) {
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

  void _onDisableTaskClicked(OneTimeTaskPresentationModel event) {
    _showConfirmDisableTaskDialog(event);
  }

  void _showConfirmDisableTaskDialog(OneTimeTaskPresentationModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remove task?"),
          content: new Text(
              "Task will remove when you accept this action! Careful!"),
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
}
