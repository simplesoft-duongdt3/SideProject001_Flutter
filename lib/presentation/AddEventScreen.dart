import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'bloc/AddTaskScreenBloc.dart';
import 'model/PresentationModel.dart';

class AddEventScreen extends StatefulWidget {
  AddEventScreen({Key key}) : super(key: key);

  @override
  _AddEventScreenState createState() {
    return _AddEventScreenState("Add tasks");
  }
}

class _AddEventScreenState extends State<AddEventScreen> {
  final String _title;
  final AddTaskScreenBloc addTaskScreenBloc = AddTaskScreenBloc();
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _textNameController = TextEditingController(text: "");
  final _textTimeExpiredController = TextEditingController(text: "");
  AddEventPresentationModel _addEventPresentationModel;

  _AddEventScreenState(this._title) {
    _addEventPresentationModel = _createEmptyAddEventModel();

  }

  AddEventPresentationModel _createEmptyAddEventModel() {
    return AddEventPresentationModel(
        "", -1, -1, false, false, false, false, false, false, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(_title),
        //hide back button
        automaticallyImplyLeading: false,
      ),
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
                  _addEventPresentationModel.expiredHour = dt.hour;
                  _addEventPresentationModel.expiredMinute = dt.minute;
                },
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.monday,
                onChanged: (value) {
                  _addEventPresentationModel.monday = value;
                  setState(() {});
                },
                title: new Text(
                  'Monday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.tuesday,
                onChanged: (value) {
                  _addEventPresentationModel.tuesday = value;
                  setState(() {});
                },
                title: new Text(
                  'Tuesday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.wednesday,
                onChanged: (value) {
                  _addEventPresentationModel.wednesday = value;
                  setState(() {});
                },
                title: new Text(
                  'Wednesday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.thursday,
                onChanged: (value) {
                  _addEventPresentationModel.thursday = value;
                  setState(() {});
                },
                title: new Text(
                  'Thursday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.friday,
                onChanged: (value) {
                  _addEventPresentationModel.friday = value;
                  setState(() {});
                },
                title: new Text(
                  'Friday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.saturday,
                onChanged: (value) {
                  _addEventPresentationModel.saturday = value;
                  setState(() {});
                },
                title: new Text(
                  'Saturday',
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: _addEventPresentationModel.sunday,
                onChanged: (value) {
                  _addEventPresentationModel.sunday = value;
                  setState(() {});
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => saveButtonClicked(),
        tooltip: "Save event",
        child: Icon(Icons.save),
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

  void _showConfirmCreateTaskDialog(AddEventPresentationModel addEventPresentationModel) {
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
                await addTaskScreenBloc.createTask(addEventPresentationModel);
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
    setState(() {

    });
  }
}
