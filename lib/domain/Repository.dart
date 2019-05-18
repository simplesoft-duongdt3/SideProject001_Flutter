import 'DomainModel.dart';

abstract class EventRepository {
  Future<void> createEvent(SaveEventDomainModel saveEventDataModel);
  Future<void> disableEvent(DisableEventDomainModel disableEventDataModel);
  Future<void> doneEvent(DoneEventDomainModel doneEventDomainModel);
  Future<List<TodayTodoDomainModel>> getTodayEvents();
  Future<List<TaskDomainModel>> getActiveTasks();
  Future<List<EventHistoryDomainModel>> getEventHistoryReport(ReportTimeEnum reportTimeEnum);
}

abstract class UserRepository {
  Future<void> signInWithGoogleAccount();
  Future<void> logout();
  Future<bool> isLogin();
  Future<LoginUserDomainModel> getCurrentUser();
}