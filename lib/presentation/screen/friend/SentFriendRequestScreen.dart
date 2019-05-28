import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/bloc/FriendScreenBloc.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

class SentFriendRequestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SentFriendRequestScreenState();
  }
}

class SentFriendRequestScreenState extends State<SentFriendRequestScreen> {
  final FriendScreenBloc _friendScreenBloc = diResolver.resolve();

  @override
  Widget build(BuildContext context) {
    return _buildSentFriendRequestContentWidget(context);
  }

  Widget _buildSentFriendRequestContentWidget(BuildContext context) {
    return Center(
      child: FutureBuilder<List<SentFriendRequestPresentationModel>>(
        future: _friendScreenBloc.loadSentFriendRequestList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<SentFriendRequestPresentationModel> eventList =
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
      List<SentFriendRequestPresentationModel> eventList) {
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
      List<SentFriendRequestPresentationModel> eventList,
      BuildContext context,
      int index) {
    SentFriendRequestPresentationModel sentRequest = eventList[index];
    return ListTile(
      leading: Icon(
        Icons.person_add,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        sentRequest.email,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {});
  }
}
