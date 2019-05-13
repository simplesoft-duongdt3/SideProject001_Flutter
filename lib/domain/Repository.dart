import 'DomainModel.dart';

abstract class EventRepository {
  void createEvent(SaveEventDomainModel saveEventDataModel);
  void disableEvent(DisableEventDomainModel disableEventDataModel);
  void doneEvent(DoneEventDomainModel doneEventDomainModel);
  List<EventDomainModel> getTodayEvents();
  List<EventHistoryDomainModel> getEventHistoryReport(ReportTimeEnum reportTimeEnum);
}