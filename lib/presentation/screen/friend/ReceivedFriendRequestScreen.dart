import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/FriendScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

class ReceivedFriendRequestScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ReceivedFriendRequestScreenState();
  }
}


class ReceivedFriendRequestScreenState extends State<ReceivedFriendRequestScreen> {
  final FriendScreenBloc _friendScreenBloc = diResolver.resolve();

  @override
  Widget build(BuildContext context) {
    return _buildSentFriendRequestContentWidget(context);
  }

  Widget _buildSentFriendRequestContentWidget(BuildContext context) {
    return Center(
      child: FutureBuilder<List<ReceivedFriendRequestPresentationModel>>(
        future: _friendScreenBloc.loadReceivedFriendRequestList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<ReceivedFriendRequestPresentationModel> eventList =
                  snapshot.data;
              if (eventList.isEmpty) {
                return buildEmptyListWidget();
              } else {
                return buildSentFriendRequestListWidget(eventList);
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

  RefreshIndicator buildSentFriendRequestListWidget(
      List<ReceivedFriendRequestPresentationModel> eventList) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.separated(
        itemBuilder: (context, index) =>
            buildSentFriendRequestListItem(eventList, context, index),
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

  Widget buildSentFriendRequestListItem(
      List<ReceivedFriendRequestPresentationModel> eventList,
      BuildContext context,
      int index) {
    ReceivedFriendRequestPresentationModel sentRequest = eventList[index];
    return ListTile(
      leading: Icon(
        Icons.person_add,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        sentRequest.email,
      ),
      trailing: InkWell(
        onTap: () async {
          _onAcceptFriendRequestClicked(sentRequest);
        },
        child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.done,
              color: Colors.green,
              size: 32,
            )),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  void _onAcceptFriendRequestClicked(ReceivedFriendRequestPresentationModel sentRequest) async {
    await _friendScreenBloc.acceptFriendRequest(AcceptFriendRequestDomainModel(
        sentRequest.requestId
    ));
    _refreshData();
  }

}