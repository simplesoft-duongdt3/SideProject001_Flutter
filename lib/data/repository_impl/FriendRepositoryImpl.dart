import 'package:flutter_app/data/FirebaseController.dart';
import 'package:flutter_app/data/FirebaseDataModel.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/domain/Util.dart';
import 'package:flutter_app/main.dart';

class FriendRepositoryImpl extends FriendRepository {
  FireDatabaseController _fireDatabaseController = diResolver.resolve();
  FireAuthController _fireAuthController = diResolver.resolve();

  @override
  Future<void> acceptFriendRequest(
      AcceptFriendRequestDomainModel acceptFriendRequestDomainModel) async {
    var loginUser = _fireAuthController.getLoginUser();
    if (loginUser != null) {
      await _fireDatabaseController.getFriendRequestRef().update({
        "status": FriendRequestStatusDataConstant.STATUS_ACCEPT,
        "updatedTime": Util.getNowUtcMilliseconds()
      });
    }
  }

  @override
  Future<List<ReceivedFriendRequestDomainModel>>
      getReceivedFriendRequests() async {
    List<ReceivedFriendRequestDomainModel> sendFriendRequestModels = [];
    var loginUser = await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var friendRequestRef = _fireDatabaseController.getFriendRequestRef();
      var dataSnapshot = await friendRequestRef
          .orderByChild("receiverUid")
          .equalTo(uid)
          .once();
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = dataSnapshot.value;

        List<FriendRequestFirebaseDataModel> histories = [];
        values.forEach((key, values) {
          histories.add(FriendRequestFirebaseDataModel.from(key, values));
        });

        sendFriendRequestModels = histories
            .map((dataModel) => _mapReceivedFriendRequest(dataModel))
            .toList(growable: false);
      }
    }
    return sendFriendRequestModels;
  }

  @override
  Future<List<FriendDomainModel>> getFriends() async {}

  @override
  Future<void> sendFriendRequest(
      FriendRequestDomainModel friendRequestDomainModel) async {
    var loginUser = await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var friendRequestRef = _fireDatabaseController.getFriendRequestRef();
      var request = FriendRequestFirebaseDataModel(
          loginUser.uid,
          loginUser.email,
          friendRequestDomainModel.uid,
          friendRequestDomainModel.email,
          FriendRequestStatusDataConstant.STATUS_SENT,
          Util.getNowUtcMilliseconds(),
          0);
      await friendRequestRef.push().set(request.toJson());
    }
  }

  @override
  Future<List<SendFriendRequestDomainModel>> getSendFriendRequests() async {
    List<SendFriendRequestDomainModel> sendFriendRequestModels = [];
    var loginUser = await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var friendRequestRef = _fireDatabaseController.getFriendRequestRef();
      var dataSnapshot =
          await friendRequestRef.orderByChild("senderUid").equalTo(uid).once();
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = dataSnapshot.value;

        List<FriendRequestFirebaseDataModel> histories = [];
        values.forEach((key, values) {
          histories.add(FriendRequestFirebaseDataModel.from(key, values));
        });

        sendFriendRequestModels = histories
            .map((dataModel) => _mapSendFriendRequest(dataModel))
            .toList(growable: false);
      }
    }
    return sendFriendRequestModels;
  }

  SendFriendRequestDomainModel _mapSendFriendRequest(
      FriendRequestFirebaseDataModel dataModel) {
    return SendFriendRequestDomainModel(dataModel.receiverEmail,
        dataModel.createdTime, _mapFriendRequestStatus(dataModel.status));
  }

  FriendRequestStatusEnum _mapFriendRequestStatus(int status) {
    if (status == FriendRequestStatusDataConstant.STATUS_ACCEPT) {
      return FriendRequestStatusEnum.STATUS_ACCEPT;
    } else if (status == FriendRequestStatusDataConstant.STATUS_DENY) {
      return FriendRequestStatusEnum.STATUS_DENY;
    } else {
      return FriendRequestStatusEnum.STATUS_SENT;
    }
  }

  ReceivedFriendRequestDomainModel _mapReceivedFriendRequest(
      FriendRequestFirebaseDataModel dataModel) {
    return ReceivedFriendRequestDomainModel(dataModel.receiverEmail,
        dataModel.createdTime, _mapFriendRequestStatus(dataModel.status));
  }
}
