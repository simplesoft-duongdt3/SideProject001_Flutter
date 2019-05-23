import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/Util.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/AddTaskScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:intl/intl.dart';

class AddOneTimeTaskScreen extends StatefulWidget {
  AddOneTimeTaskScreen({Key key}) : super(key: key);

  @override
  _AddOneTimeTaskScreenState createState() {
    return _AddOneTimeTaskScreenState();
  }
}

class _AddOneTimeTaskScreenState extends State<AddOneTimeTaskScreen> {
  final AddTaskScreenBloc addTaskScreenBloc = diResolver.resolve();
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _textNameController = TextEditingController(text: "");
  final _textTimeExpiredController = TextEditingController(text: "");
  final _textDateExpiredController = TextEditingController(text: "");
  AddOneTimeTaskPresentationModel _addEventPresentationModel;

  _AddOneTimeTaskScreenState() {
    _addEventPresentationModel = _createEmptyAddEventModel();
  }

  AddOneTimeTaskPresentationModel _createEmptyAddEventModel() {
    return AddOneTimeTaskPresentationModel(
      "",
      -1,
      -1,
      -1,
      -1,
      -1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: Form(
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
              controller: _textDateExpiredController,
              inputType: InputType.date,
              format: DateFormat("dd/MM/yyyy"),
              initialDate: DateTime.now(),
              editable: false,
              decoration: InputDecoration(
                  labelText: 'Task expired date',
                  hasFloatingPlaceholder: false),
              onChanged: (dt) {
                if (dt != null) {
                  _addEventPresentationModel.expiredDay = dt.day;
                  _addEventPresentationModel.expiredMonth = dt.month;
                  _addEventPresentationModel.expiredYear = dt.year;
                }
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "oneTimeHeroTag",
        onPressed: () => saveButtonClicked(),
        tooltip: "Save event",
        icon: Icon(Icons.save),
        label: Text("Save"),
      ),
    );
  }

  void saveButtonClicked() async {
    final FormState form = _addFormKey.currentState;
    if (form.validate() && _validateExpiredTime() && _validateExpiredDate()) {
      form.save();
      _showConfirmCreateTaskDialog(_addEventPresentationModel);
    }
  }

  void _showConfirmCreateTaskDialog(
      AddOneTimeTaskPresentationModel addEventPresentationModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Create new one time task?"),
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
                await addTaskScreenBloc.createOneTimeTask(addEventPresentationModel);
                _refreshData();
                _showUserWarning("Create task successful!");
              },
            ),
          ],
        );
      },
    );
  }

  void _showUserWarning(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 2000),
    );
    _scaffoldState.currentState.showSnackBar(snackBar);
  }

  bool _validateExpiredDate() {
    var validExpiredDate = _addEventPresentationModel.expiredYear >= 0 ||
        _addEventPresentationModel.expiredMonth >= 0 && _addEventPresentationModel.expiredDay >= 0;

    if (!validExpiredDate) {
      _showUserWarning('Input expired date.');
    }

    if (validExpiredDate) {
      var dateExpired = Util.calcTaskDateExpired(_addEventPresentationModel.expiredYear, _addEventPresentationModel.expiredMonth, _addEventPresentationModel.expiredDay);
      var now = Util.calcTaskDateToday();
      validExpiredDate = dateExpired >= now;

      if (!validExpiredDate) {
        _showUserWarning('Expired date is not valid.');
      }
    }

    return validExpiredDate;
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
    setState(() {
      _addEventPresentationModel = _createEmptyAddEventModel();
      _textNameController.clear();
      _textTimeExpiredController.clear();
      _textDateExpiredController.clear();
    });
  }
}
