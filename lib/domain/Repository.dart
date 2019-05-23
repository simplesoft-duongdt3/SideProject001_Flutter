import 'DomainModel.dart';

abstract class EventRepository {
  Future<void> createDailyTask(SaveDailyTaskDomainModel saveEventDataModel);
  Future<void> createOneTimeTask(SaveOneTimeTaskDomainModel saveEventDataModel);
  Future<void> disableDailyEvent(DisableDailyTaskDomainModel disableEventDataModel);
  Future<void> disableOneTimeEvent(DisableOneTimeTaskDomainModel disableEventDataModel);

  Future<void> doneDailyTask(
      DoneDailyTaskDomainModel doneDailyTimeTaskDomainModel);

  Future<void> doneOneTimeTask(
      DoneOneTimeTaskDomainModel doneOneTimeTaskDomainModel);
  Future<List<TodayTodoDomainModel>> getTodayTodos();
  Future<List<DailyTaskDomainModel>> getActiveDailyTasks();
  Future<List<OneTimeTaskDomainModel>> getActiveOneTimeTasks();
  Future<List<TaskHistoryDomainModel>> getTaskHistoryReport(
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
