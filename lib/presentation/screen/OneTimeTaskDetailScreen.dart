import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/bloc/AddTaskScreenBloc.dart';
import 'package:flutter_app/presentation/bloc/TaskDetailScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class OneTimeTaskDetailScreen extends StatelessWidget {
  final String _taskId;
  OneTimeTaskDetailScreen(this._taskId, {Key key}) : super(key: key);
  final TaskDetailScreenBloc taskDetailScreenBloc = diResolver.resolve();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Onetime task detail"),
        //hide back button
        //automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: taskDetailScreenBloc.getOneTimeTaskDetail(_taskId),
          builder: (context, snapshot) {
            return _buildContent(context, snapshot);
          },
        ),
      )
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        OneTimeTaskDetailPresentationModel taskDetail = snapshot.data;
        return _buildTaskDetailWidget(taskDetail);
      } else {
        return _buildErrorWidget();
      }
    } else {
      return _buildLoadingWidget();
    }
  }

  Widget _buildErrorWidget() {
    return Text(
      "Something wrong occured here, guys!",
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingWidget() {
    return CircularProgressIndicator();
  }

  Widget _buildTaskDetailWidget(OneTimeTaskDetailPresentationModel taskDetail) {
    var timeFormat = new NumberFormat("00", "en_US");
    return new ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: <Widget>[
        TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Task name',
          ),
          initialValue: taskDetail.name,
        ),
        TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Task expired date',
          ),
          initialValue: '${timeFormat.format(taskDetail.expiredDay)}/${timeFormat.format(taskDetail.expiredMonth)}/${taskDetail.expiredYear}',
        ),
        TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Task expired time',
          ),
          initialValue: '${timeFormat.format(taskDetail.expiredHour)}:${timeFormat.format(taskDetail.expiredMinute)}',
        ),
      ],
    );
  }
}