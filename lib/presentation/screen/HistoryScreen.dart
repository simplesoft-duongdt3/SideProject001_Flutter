import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/HistoryScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final String userUid;

  HistoryScreen({Key key, this.userUid}) : super(key: key);

  @override
  HistoryScreenState createState() {
    return HistoryScreenState("History", userUid: userUid);
  }
}

class HistoryScreenState extends State<HistoryScreen> {
  final String userUid;

  HistoryScreenState(this._title, {this.userUid});

  final String _title;
  final HistoryScreenBloc _mainScreenBloc = diResolver.resolve();
  var timeFormat = new NumberFormat("00", "en_US");

  final List<ReportTimeEnum> _reportTabs = ReportTimeEnum.values;

  //default today tab
  final int _initTabPos = 0;

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
            isScrollable: true,
          ),
        ),
        body: _createTabViews(context),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return <Widget>[for (var report in _reportTabs) _createTabReport(report)];
  }

  Widget _createTabReport(ReportTimeEnum report) {
    switch (report) {
      case ReportTimeEnum.TODAY:
        return Tab(text: "Today");
        break;
      case ReportTimeEnum.YESTERDAY:
        return Tab(text: "Yesterday");
        break;
      case ReportTimeEnum.LAST_WEEK:
        return Tab(text: "Last week");
        break;
      case ReportTimeEnum.THIS_WEEK:
        return Tab(text: "This week");
        break;
    }
    return Tab(text: "Unknown");
  }

  Widget _buildContentWidget(BuildContext context, ReportTimeEnum reportTime) {
    return Center(
      child: FutureBuilder<List<TaskHistoryPresentationModel>>(
        future: userUid != null ? _mainScreenBloc.loadFriendHistoryList(
            userUid, reportTime) : _mainScreenBloc.loadHistoryList(reportTime),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<TaskHistoryPresentationModel> eventList = snapshot.data;
              if (eventList.isEmpty) {
                return buildEmptyListWidget();
              } else {
                return buildListWidget(eventList, reportTime);
              }
            } else {
              return buildErrorWidget();
            }
          } else {
            return buildLoadingWidget();
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

  RefreshIndicator buildListWidget(List<TaskHistoryPresentationModel> eventList,
      ReportTimeEnum reportTime) {
    bool isShowDate = reportTime == ReportTimeEnum.THIS_WEEK ||
        reportTime == ReportTimeEnum.LAST_WEEK;
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.separated(
        itemBuilder: (context, index) =>
            buildListItem(eventList, context, index, isShowDate),
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

  Widget buildListItem(List<TaskHistoryPresentationModel> eventList,
      BuildContext context, int index, bool isShowDate) {
    TaskHistoryPresentationModel history = eventList[index];

    var formattedDay = timeFormat.format(history.expiredDay);
    var formattedMonth = timeFormat.format(history.expiredMonth);
    var formattedHour = timeFormat.format(history.expiredHour);
    var formattedMinute = timeFormat.format(history.expiredMinute);
    var dateTime = isShowDate
        ? '$formattedDay/$formattedMonth/${history
        .expiredYear} $formattedHour:$formattedMinute'
        : '$formattedHour:$formattedMinute';
    return ListTile(
      leading: Icon(
        Icons.event_note,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        history.eventName,
      ),
      subtitle: Text(
        dateTime,
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
    switch (status) {
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

  Widget _createTabViews(BuildContext context) {
    return TabBarView(
      children: [
        for (var report in _reportTabs) _buildContentWidget(context, report)
      ],
    );
  }
}
