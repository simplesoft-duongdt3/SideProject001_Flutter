import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/AddTaskScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

class AddDailyTaskScreen extends StatefulWidget {
  AddDailyTaskScreen({Key key}) : super(key: key);

  @override
  _AddDailyTaskScreenState createState() {
    return _AddDailyTaskScreenState();
  }
}

class _AddDailyTaskScreenState extends State<AddDailyTaskScreen> {
  final AddTaskScreenBloc addTaskScreenBloc = diResolver.resolve();
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _textNameController = TextEditingController(text: "");
  final _textTimeExpiredController = TextEditingController(text: "");
  AddDailyTaskPresentationModel _addEventPresentationModel;

  _AddDailyTaskScreenState() {
    _addEventPresentationModel = _createEmptyAddEventModel();
  }

  AddDailyTaskPresentationModel _createEmptyAddEventModel() {
    return AddDailyTaskPresentationModel(
        "", -1, -1, false, false, false, false, false, false, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: Center(
        child: Form(
          key: _addFormKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              TextFormField(
                controller: _textNameController,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                  labelText: 'Task name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter task name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addEventPresentationModel.name = value;
                },
              ),
              DateTimePickerFormField(
                controller: _textTimeExpiredController,
                inputType: InputType.time,
                format: DateFormat("HH:mm"),
                initialTime: TimeOfDay(hour: 0, minute: 0),
                editable: false,
                decoration: InputDecoration(
                    labelText: 'Task expired time',
                    hasFloatingPlaceholder: false),
                onChanged: (dt) {
                  if (dt != null) {
                    _addEventPresentationModel.expiredHour = dt.hour;
                    _addEventPresentationModel.expiredMinute = dt.minute;
                  }
                },
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.isDaily,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.applyAllDayOfWeek(value);
                  });
                },
                title: new Text(
                  'All days of Week',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.monday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.monday = value;
                  });
                },
                title: new Text(
                  'Monday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.tuesday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.tuesday = value;
                  });
                },
                title: new Text(
                  'Tuesday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.wednesday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.wednesday = value;
                  });
                },
                title: new Text(
                  'Wednesday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.thursday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.thursday = value;
                  });
                },
                title: new Text(
                  'Thursday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.friday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.friday = value;
                  });
                },
                title: new Text(
                  'Friday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.saturday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.saturday = value;
                  });
                },
                title: new Text(
                  'Saturday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.sunday,
                onChanged: (value) {
                  setState(() {
                    _addEventPresentationModel.sunday = value;
                  });
                },
                title: new Text(
                  'Sunday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "dailyHeroTag",
        onPressed: () => saveButtonClicked(),
        tooltip: "Save event",
        icon: Icon(Icons.save),
        label: Text("Save"),
      ),
    );
  }

  void saveButtonClicked() async {
    final FormState form = _addFormKey.currentState;
    if (form.validate() && _validateExpiredTime() && _validateWeekdays()) {
      form.save();
      _showConfirmCreateTaskDialog(_addEventPresentationModel);
    }
  }

  void _showConfirmCreateTaskDialog(
      AddDailyTaskPresentationModel addEventPresentationModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Create new task?"),
          content:
              new Text("Task will be created when you accept this action!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                //nothing to do
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("CREATE"),
              onPressed: () async {
                Navigator.of(context).pop();
                await addTaskScreenBloc
                    .createDailyTask(addEventPresentationModel);
                _refreshData();
                _showUserWarning("Create task successful!");
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateWeekdays() {
    var validWeekdays = _addEventPresentationModel.monday ||
        _addEventPresentationModel.tuesday ||
        _addEventPresentationModel.wednesday ||
        _addEventPresentationModel.thursday ||
        _addEventPresentationModel.friday ||
        _addEventPresentationModel.saturday ||
        _addEventPresentationModel.sunday;

    if (!validWeekdays) {
      var msg = 'Input at least once weekdays.';
      _showUserWarning(msg);
    }
    return validWeekdays;
  }

  void _showUserWarning(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 2000),
    );
    _scaffoldState.currentState.showSnackBar(snackBar);
  }

  bool _validateExpiredTime() {
    var validExpiredTime = _addEventPresentationModel.expiredHour >= 0 ||
        _addEventPresentationModel.expiredHour >= 0;

    if (!validExpiredTime) {
      _showUserWarning('Input expired time.');
    }
    return validExpiredTime;
  }

  void _refreshData() {
    _addEventPresentationModel = _createEmptyAddEventModel();
    _textNameController.clear();
    _textTimeExpiredController.clear();
    setState(() {});
  }
}
