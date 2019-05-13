import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';

import 'DataModel.dart';

class EventRepositoryImpl implements EventRepository {
  List<EventDataModel> databaseEventFake = [];
  List<EventHistoryDataModel> databaseHistoryFake = [];

  @override
  void createEvent(SaveEventDomainModel saveEventDataModel) {
    int nextItemId = _getNextItemId();
    bool defaultEventEnable = true;
    var nowMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
    int createdTime = nowMilliseconds;
    int updatedTime = 0;
    int enableTimeStart = nowMilliseconds;
    int enableTimeEnd = 0;
    EventDataModel eventDataModel = EventDataModel(
        nextItemId,
        saveEventDataModel.name,
        saveEventDataModel.expiredHour,
        saveEventDataModel.expiredMinute,
        saveEventDataModel.weekdays,
        defaultEventEnable,
        enableTimeStart,
        enableTimeEnd,
        createdTime,
        updatedTime
    );

    databaseEventFake.add(eventDataModel);
  }

  int _getNextItemId() {
    int nextItemId = 0;
    var lastItem = databaseEventFake.last;
    if (lastItem != null) {
      nextItemId = lastItem.id + 1;
    } else {
      nextItemId = 1;
    }
    return nextItemId;
  }

  @override
  void disableEvent(DisableEventDomainModel disableEventDataModel) {
    var checkCurrentEventId = (event) => event.id == disableEventDataModel.eventId;
    var findEvent = databaseEventFake.firstWhere(checkCurrentEventId);
    if (findEvent != null) {
      var nowMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
      findEvent.enable = false;
      findEvent.enableTimeEnd = nowMilliseconds;
      findEvent.updateTime = nowMilliseconds;
    }
  }

  @override
  void doneEvent(DoneEventDomainModel doneEventDomainModel) {
    var checkCurrentEventId = (event) => event.id == doneEventDomainModel.eventId;
    var findEvent = databaseEventFake.firstWhere(checkCurrentEventId);

    if (findEvent != null) {
      var nowMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
      var doneTime = nowMilliseconds;
      var createdTime = nowMilliseconds;
      bool isDone = true;
      EventHistoryDataModel eventHistoryDataModel = EventHistoryDataModel(
          findEvent.id,
          findEvent.name,
          isDone,
          doneTime,
          findEvent.expiredHour,
          findEvent.expiredMinute,
          createdTime
      );
      databaseHistoryFake.add(eventHistoryDataModel);
    }
  }

  @override
  List<EventHistoryDomainModel> getEventHistoryReport(ReportTimeEnum reportTimeEnum) {
    // TODO: implement getEventHistoryReport
    return null;
  }

  @override
  List<EventDomainModel> getTodayEvents() {
    var nowWeekday = DateTime.now().weekday;
    List<EventDomainModel> matchedEvents = databaseEventFake
        .where((event) => event.weekdays.contains(nowWeekday))
        .map((eventDataModel) => _mapEventDataToEventDomain(eventDataModel));
    return matchedEvents;
  }

  EventDomainModel _mapEventDataToEventDomain(EventDataModel eventDataModel) {
    return EventDomainModel(
        eventDataModel.id,
        eventDataModel.name,
        eventDataModel.expiredHour,
        eventDataModel.expiredMinute,
        eventDataModel.weekdays
    );
  }
}