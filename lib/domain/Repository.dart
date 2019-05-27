import 'DomainModel.dart';

abstract class TaskRepository {
  Future<void> createDailyTask(SaveDailyTaskDomainModel saveEventDataModel);

  Future<void> createOneTimeTask(SaveOneTimeTaskDomainModel saveEventDataModel);

  Future<void> disableDailyEvent(
      DisableDailyTaskDomainModel disableEventDataModel);

  Future<void> disableOneTimeEvent(
      DisableOneTimeTaskDomainModel disableEventDataModel);

  Future<void> doneDailyTask(
      DoneDailyTaskDomainModel doneDailyTimeTaskDomainModel);

  Future<void> doneOneTimeTask(
      DoneOneTimeTaskDomainModel doneOneTimeTaskDomainModel);

  Future<List<TodayTodoDomainModel>> getTodayTodos();

  Future<List<DailyTaskDomainModel>> getActiveDailyTasks();

  Future<List<OneTimeTaskDomainModel>> getActiveOneTimeTasks();

  Future<List<TaskHistoryDomainModel>> getTaskHistoryReport(
      ReportTimeEnum reportTimeEnum);

  Future<List<TaskHistoryDomainModel>> getUserTaskHistoryReport(String userUid,
      ReportTimeEnum reportTimeEnum);

  Future<DailyTaskDetailDomainModel> getDailyTaskDetail(String taskId);

  Future<OneTimeTaskDetailDomainModel> getOneTimeTaskDetail(String taskId);
}

abstract class UserRepository {
  Future<void> signInWithGoogleAccount();

  Future<void> logout();

  Future<bool> isLogin();

  Future<LoginUserDomainModel> getCurrentUser();
}

abstract class FriendRepository {
  Future<List<ReceivedFriendRequestDomainModel>> getReceivedFriendRequests();

  Future<List<SentFriendRequestDomainModel>> getSendFriendRequests();

  Future<List<FriendDomainModel>> getFriends();

  Future<void> acceptFriendRequest(
      AcceptFriendRequestDomainModel acceptFriendRequestDomainModel);

  Future<void> sendFriendRequest(
      FriendRequestDomainModel friendRequestDomainModel);
}
