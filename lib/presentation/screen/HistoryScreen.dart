import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/presentation/bloc/HistoryScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

import '../../main.dart';


class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  HistoryScreenState createState() {
    return HistoryScreenState("History");
  }
}

class HistoryScreenState extends State<HistoryScreen> {
  final String _title;
  final HistoryScreenBloc _mainScreenBloc = diResolver.resolve();
  var timeFormat = new NumberFormat("00", "en_US");

  final List<ReportTimeEnum> _reportTabs = [ReportTimeEnum.LAST_WEEK, ReportTimeEnum.YESTERDAY, ReportTimeEnum.TODAY];
  //default today tab
  final int _initTabPos = 2;

  HistoryScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _initTabPos,
      length: _reportTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          bottom: TabBar(
            tabs: _buildTabs(),
          ),
        ),
        body: TabBarView(
          children: _createTabViews(context),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return <Widget>[
      for(var report in _reportTabs) _createTabReport(report)
    ];
  }

  Widget _createTabReport(ReportTimeEnum report) {
    switch(report) {

      case ReportTimeEnum.TODAY:
        return Tab(text: "Today");
        break;
      case ReportTimeEnum.YESTERDAY:
        return Tab(text: "Yesterday");
        break;
      case ReportTimeEnum.LAST_WEEK:
        return Tab(text: "Last week");
        break;
    }
    return Tab(text: "Unknown");
  }

  Widget _buildContentWidget(BuildContext context, ReportTimeEnum reportTime) {
    return FutureBuilder<List<TaskHistoryPresentationModel>>(
      future: _mainScreenBloc.loadHistoryList(reportTime),
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
          '${timeFormat.format(history.expiredHour)}:${timeFormat.format(history.expiredMinute)}',
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
      case TaskStatus.DONE_LATE:
        return "Done late";
        break;
    }
    return "Unknown";
  }

  List<Widget> _createTabViews(BuildContext context) {
    return [
      for(var report in _reportTabs) _buildContentWidget(context, report)
    ];
  }
}
