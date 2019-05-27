import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

class FriendScreenBloc {
  FriendRepository _friendRepository = diResolver.resolve();

  Future<void> sendFriendRequest(
      FriendRequestPresentationModel friendRequestPresentationModel) async {
    await _friendRepository.sendFriendRequest(FriendRequestDomainModel(
      friendRequestPresentationModel.uid,
      friendRequestPresentationModel.email,
    ));
  }

  Future<void> acceptFriendRequest(
      AcceptFriendRequestDomainModel acceptFriendRequestDomainModel) async {
    await _friendRepository.acceptFriendRequest(acceptFriendRequestDomainModel);
  }

  Future<List<SentFriendRequestPresentationModel>>
      loadSentFriendRequestList() async {
    var sentFriendRequests = await _friendRepository.getSendFriendRequests();
    return _mapSentFriendRequest(sentFriendRequests);
  }

  Future<List<FriendPresentationModel>> loadFriendList() async {
    var sentFriendRequests = await _friendRepository.getFriends();
    return _mapFriend(sentFriendRequests);
  }

  List<SentFriendRequestPresentationModel> _mapSentFriendRequest(
      List<SentFriendRequestDomainModel> sentFriendRequests) {
    return sentFriendRequests
        .map((sentRequest) => SentFriendRequestPresentationModel(
            sentRequest.requestId,
            sentRequest.email,
            sentRequest.requestTime,
            sentRequest.status))
        .toList(growable: false);
  }

  List<ReceivedFriendRequestPresentationModel> _mapReceivedFriendRequest(
      List<ReceivedFriendRequestDomainModel> receivedFriendRequests) {
    return receivedFriendRequests
        .map((sentRequest) => ReceivedFriendRequestPresentationModel(
            sentRequest.requestId,
            sentRequest.email,
            sentRequest.requestTime,
            sentRequest.status))
        .toList(growable: false);
  }

  Future<List<ReceivedFriendRequestPresentationModel>>
      loadReceivedFriendRequestList() async {
    var sentFriendRequests =
        await _friendRepository.getReceivedFriendRequests();
    return _mapReceivedFriendRequest(sentFriendRequests);
  }

  List<FriendPresentationModel> _mapFriend(
      List<FriendDomainModel> sentFriendRequests) {
    return sentFriendRequests
        .map((friend) => FriendPresentationModel(
              friend.uid,
              friend.email,
            ))
        .toList(growable: false);
  }
}
