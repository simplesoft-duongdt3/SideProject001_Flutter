import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/bloc/ShareQrScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../main.dart';

class ShareQrScreen extends StatefulWidget {
  final String title = 'Share Qr Code';

  @override
  State<StatefulWidget> createState() => ShareQrScreenState();
}

class ShareQrScreenState extends State<ShareQrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (BuildContext context) {
        return _ShareQrSection();
      }),
    );
  }
}

class _ShareQrSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShareQrSectionState();
}

class _ShareQrSectionState extends State<_ShareQrSection> {
  ShareQrScreenBloc _shareQrScreenBloc = diResolver.resolve();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: FutureBuilder<LoginUserPresentationModel>(
            future: _shareQrScreenBloc.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    LoginUserPresentationModel user = snapshot.data;
                    if (user != null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          QrImage(
                            data: user.qrCodeContent,
                            size: 200.0,
                          ),
                          Text(
                            user.userName
                          ),
                          Text(
                              user.email
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Text(
                      "Something wrong occured here, guys!",
                      textAlign: TextAlign.center,
                    );
                  }
                }
              }
            }
        ),
      ),
    );
  }

  void _goToHomeScreen() {
    Navigator.of(context).pushReplacementNamed('/main');
  }
}
