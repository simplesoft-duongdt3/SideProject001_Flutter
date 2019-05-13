import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddEventScreen extends StatefulWidget {
  AddEventScreen({Key key}) : super(key: key);

  @override
  _AddEventScreenState createState() {
    return _AddEventScreenState("Add event screen");
  }
}

class _AddEventScreenState extends State<AddEventScreen> {
  final String _title;
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();

  _AddEventScreenState(this._title);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        //hide back button
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          key: _addFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Event name'
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveButtonClicked,
        tooltip: "Save event",
        child: Icon(
          Icons.save
        ),
      ),
    );
  }

  void saveButtonClicked() {

  }
}
