import 'DomainModel.dart';

abstract class EventRepository {
  Future<void> createEvent(SaveEventDomainModel saveEventDataModel);
  Future<void> disableEvent(DisableEventDomainModel disableEventDataModel);
  Future<void> doneEvent(DoneEventDomainModel doneEventDomainModel);
  Future<List<EventDomainModel>> getTodayEvents();
  Future<List<EventHistoryDomainModel>> getEventHistoryReport(ReportTimeEnum reportTimeEnum);
}