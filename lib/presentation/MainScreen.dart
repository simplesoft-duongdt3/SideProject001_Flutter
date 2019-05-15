import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/presentation/bloc/MainScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  MainScreenState createState() {
    return MainScreenState("Tasks");
  }
}

class MainScreenState extends State<MainScreen> {
  final String _title;
  final MainScreenBloc _mainScreenBloc = MainScreenBloc();
  bool isLoading = true;

  MainScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              _onHistoryClicked();
            },
          ),
        ],
      ),
      body: Center(
        child: buildContentWidget(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonClicked,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildContentWidget(BuildContext context) {
    return FutureBuilder<List<EventPresentationModel>>(
      future: _mainScreenBloc.loadEventList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<EventPresentationModel> eventList = snapshot.data;
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

  RefreshIndicator buildListWidget(List<EventPresentationModel> eventList) {
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
          "You don't have any tasks, today!\nClick here to reload!",
          textAlign: TextAlign.center,
        ),
        onTap: _refreshData,
      ),
    );
  }

  Widget buildListItem(
      List<EventPresentationModel> eventList, BuildContext context, int index) {
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
        '${event.expiredHour}:${event.expiredMinute}',
      ),
      trailing: buildStatusWidget(event),
    );
  }

  Widget buildStatusWidget(EventPresentationModel event) {
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
    } else if (event.status == TaskStatus.OUT_OF_TIME) {
      return InkWell(
        onTap: () {
          _onDoneTaskClicked(event);
        },
        child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.alarm_off,
              color: Colors.red,
              size: 32,
            )),
      );
    } else {
      return null;
    }
  }

  void _onAddButtonClicked() {
    Navigator.pushNamed(context, '/add_event');
  }

  void _onDoneTaskClicked(EventPresentationModel event) {
    _showConfirmDoneTaskDialog(event);
  }

  void _showConfirmDoneTaskDialog(EventPresentationModel event) {
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

  Future<void> _refreshData() async {
    setState(() {});
  }

  void _onHistoryClicked() {
    Navigator.pushNamed(context, '/task_history');
  }
}
