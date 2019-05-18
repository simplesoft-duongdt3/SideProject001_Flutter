import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/presentation/bloc/AddTaskScreenBloc.dart';
import 'package:flutter_app/presentation/bloc/TaskDetailScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class TaskDetailScreen extends StatelessWidget {
  final String _taskId;
  TaskDetailScreen(this._taskId, {Key key}) : super(key: key);
  final TaskDetailScreenBloc taskDetailScreenBloc = diResolver.resolve();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task detail"),
        //hide back button
        //automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: taskDetailScreenBloc.getTaskDetail(_taskId),
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
        TaskDetailPresentationModel taskDetail = snapshot.data;
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

  Widget _buildTaskDetailWidget(TaskDetailPresentationModel taskDetail) {
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
            labelText: 'Task expired time',
          ),
          initialValue: '${timeFormat.format(taskDetail.expiredHour)}:${timeFormat.format(taskDetail.expiredMinute)}',
        ),
        CheckboxListTile(
          value: taskDetail.monday,
          title: new Text(
            'Monday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: taskDetail.tuesday,
          title: new Text(
            'Tuesday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: taskDetail.wednesday,
          title: new Text(
            'Wednesday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: taskDetail.thursday,
          title: new Text(
            'Thursday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: taskDetail.friday,
          title: new Text(
            'Friday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: taskDetail.saturday,
          title: new Text(
            'Saturday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          value: taskDetail.sunday,
          title: new Text(
            'Sunday',
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}