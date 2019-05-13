import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  MainScreen({ Key key }) : super(key: key);

  @override
  _MainScreenState createState() {
    return _MainScreenState("Main screen");
  }
}

class _MainScreenState extends State<MainScreen> {
  final String _title;

  _MainScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MainScreen',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonClicked,
        tooltip: 'Add event',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addButtonClicked() {
    Navigator.pushNamed(context, '/add_event');
  }
}