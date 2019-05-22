import 'DomainModel.dart';

abstract class EventRepository {
  Future<void> createDailyTask(SaveDailyTaskDomainModel saveEventDataModel);
  Future<void> createOneTimeTask(SaveOneTimeTaskDomainModel saveEventDataModel);
  Future<void> disableDailyEvent(DisableDailyTaskDomainModel disableEventDataModel);
  Future<void> disableOneTimeEvent(DisableOneTimeTaskDomainModel disableEventDataModel);
  Future<void> doneEvent(DoneDailyTaskDomainModel doneEventDomainModel);
  Future<List<TodayTodoDomainModel>> getTodayTodos();
  Future<List<TaskDomainModel>> getActiveDailyTasks();
  Future<List<TaskDomainModel>> getActiveOneTimeTasks();
  Future<List<TaskHistoryDomainModel>> getTaskHistoryReport(
      ReportTimeEnum reportTimeEnum);
  Future<TaskDetailDomainModel> getTaskDailyDetail(String taskId);
}

abstract class UserRepository {
  Future<void> signInWithGoogleAccount();
  Future<void> logout();
  Future<bool> isLogin();
  Future<LoginUserDomainModel> getCurrentUser();
}
