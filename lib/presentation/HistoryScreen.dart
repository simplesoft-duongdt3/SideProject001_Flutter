import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import 'bloc/HistoryScreenBloc.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  HistoryScreenState createState() {
    return HistoryScreenState("History");
  }
}

class HistoryScreenState extends State<HistoryScreen> {
  final String _title;
  final HistoryScreenBloc _mainScreenBloc = HistoryScreenBloc();
  bool isLoading = true;

  ReportTimeEnum _reportTime = ReportTimeEnum.TODAY;

  HistoryScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: buildContentWidget(context),
      ),
    );
  }

  Widget buildContentWidget(BuildContext context) {
    return FutureBuilder<List<TaskHistoryPresentationModel>>(
      future: _mainScreenBloc.loadHistoryList(_reportTime),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<TaskHistoryPresentationModel> eventList = snapshot.data;
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

  RefreshIndicator buildListWidget(List<TaskHistoryPresentationModel> eventList) {
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
          "You don't have any history!\nClick here to reload!",
          textAlign: TextAlign.center,
        ),
        onTap: _refreshData,
      ),
    );
  }

  Widget buildListItem(
      List<TaskHistoryPresentationModel> eventList, BuildContext context, int index) {
    TaskHistoryPresentationModel history = eventList[index];
    return ListTile(
      leading: Icon(
        Icons.event_note,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        history.eventName,
      ),
      subtitle: Text(
        '${history.expiredHour}:${history.expiredMinute}',
      ),
      trailing: Text(
        _mapTextFromStatus(history.status),
      ),
    );
  }


  Future<void> _refreshData() async {
    setState(() {});
  }

  String _mapTextFromStatus(TaskStatus status) {
    switch(status) {

      case TaskStatus.TODO:
        return "To do";
        break;
      case TaskStatus.DONE:
        return "Done";
        break;
      case TaskStatus.OUT_OF_TIME:
        return "Out of time";
        break;
    }
    return "Unknown";
  }
}
