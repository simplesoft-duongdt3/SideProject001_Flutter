import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/FriendScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:flutter_app/presentation/route/RouteProvider.dart';
import 'package:flutter_app/presentation/screen/friend/ListFriendScreen.dart';
import 'package:flutter_app/presentation/screen/friend/ReceivedFriendRequestScreen.dart';
import 'package:flutter_app/presentation/screen/friend/SentFriendRequestScreen.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({Key key}) : super(key: key);

  @override
  FriendsScreenState createState() {
    return FriendsScreenState("Friends");
  }
}

class FriendsScreenState extends State<FriendsScreen> {
  final String _title;
  final RouterProvider _routerProvider = diResolver.resolve();
  final FriendScreenBloc _friendScreenBloc = diResolver.resolve();

  FriendsScreenState(this._title);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          bottom: TabBar(
            tabs: _buildTabs(),
            isScrollable: true,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _onShareClicked();
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                _onScanQrClicked();
              },
            ),
          ],
        ),
        body: _createTabViews(context),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return <Widget>[
      Tab(text: "Friends"),
      Tab(text: "Received request"),
      Tab(text: "Sent request"),
    ];
  }

  Widget _createTabViews(BuildContext context) {
    return TabBarView(
      children: [
        ListFriendScreen(),
        ReceivedFriendRequestScreen(),
        SentFriendRequestScreen(),
      ],
    );
  }

  void _onShareClicked() {
    Navigator.of(context).push(_routerProvider.getShareQrScreen());
  }

  void _onScanQrClicked() async {
    await scan();
  }

  Future<void> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      if (barcode != null && barcode.isNotEmpty) {
        var loginUserDomainModel =
        LoginUserDomainModel.fromQrCodeContent(barcode);
        await _friendScreenBloc.sendFriendRequest(FriendRequestPresentationModel(
          loginUserDomainModel.uid,
          loginUserDomainModel.email,
        ));
        _showSendRequestFriendSuccess(loginUserDomainModel.email);
      }
    } catch (e) {
      if (e is FormatException) {
        //nothing to do
      } else {
        _showErrorScanDialog();
      }
    }
  }

  void _showErrorScanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Scan fail"),
          content: new Text(
              "Something wrong happened when you scan friend QR code."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                //nothing to do
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSendRequestFriendSuccess(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Send friend request success"),
          content: new Text(
              "Wait for $email accept your request."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              onPressed: () {
                //nothing to do
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
