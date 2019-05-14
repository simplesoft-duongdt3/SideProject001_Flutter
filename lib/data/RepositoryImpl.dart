import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';

import 'DataModel.dart';

class EventRepositoryImpl implements EventRepository {
  static List<EventDataModel> databaseEventFake = [];
  static List<EventHistoryDataModel> databaseHistoryFake = [];

  @override
  Future<void> createEvent(SaveEventDomainModel saveEventDataModel) async {
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
        defaultEventEnable,
        enableTimeStart,
        enableTimeEnd,
        createdTime,
        updatedTime,
        saveEventDataModel.monday,
        saveEventDataModel.tuesday,
        saveEventDataModel.wednesday,
        saveEventDataModel.thursday,
        saveEventDataModel.friday,
        saveEventDataModel.saturday,
        saveEventDataModel.sunday
    );

    databaseEventFake.add(eventDataModel);
  }

  int _getNextItemId() {
    int nextItemId = 0;
    var lastItem = databaseEventFake.isEmpty ? null : databaseEventFake[databaseEventFake.length - 1];
    if (lastItem != null) {
      nextItemId = lastItem.id + 1;
    } else {
      nextItemId = 1;
    }
    return nextItemId;
  }

  @override
  Future<void> disableEvent(
      DisableEventDomainModel disableEventDataModel) async {
    var checkCurrentEventId =
        (event) => event.id == disableEventDataModel.eventId;
    var findEvent = databaseEventFake.firstWhere(checkCurrentEventId);
    if (findEvent != null) {
      var nowMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
      findEvent.enable = false;
      findEvent.enableTimeEnd = nowMilliseconds;
      findEvent.updateTime = nowMilliseconds;
    }
  }

  @override
  Future<void> doneEvent(DoneEventDomainModel doneEventDomainModel) async {
    var checkCurrentEventId =
        (event) => event.id == doneEventDomainModel.eventId;
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
          createdTime);
      databaseHistoryFake.add(eventHistoryDataModel);
    }
  }

  @override
  Future<List<EventHistoryDomainModel>> getEventHistoryReport(
      ReportTimeEnum reportTimeEnum) async {
    // TODO: implement getEventHistoryReport
    return null;
  }

  @override
  Future<List<EventDomainModel>> getTodayEvents() async {
    await new Future.delayed(const Duration(seconds: 3));
    List<EventDomainModel> matchedEvents = databaseEventFake
        .where((event) => _checkWeekdayInToday(event))
        .map((eventDataModel) => _mapEventDataToEventDomain(eventDataModel))
        .toList(growable: true);
    return matchedEvents;
  }

  EventDomainModel _mapEventDataToEventDomain(EventDataModel eventDataModel) {
    print(eventDataModel);
    return EventDomainModel(
        eventDataModel.id,
        eventDataModel.name,
        eventDataModel.expiredHour,
        eventDataModel.expiredMinute);
  }

  List<int> buildWeekdays(SaveEventDomainModel saveEventDataModel) {
    List<int> result = [];
    if (saveEventDataModel.sunday) {
      result.add(DateTime.sunday);
    }
    if (saveEventDataModel.monday) {
      result.add(DateTime.monday);
    }
    if (saveEventDataModel.tuesday) {
      result.add(DateTime.tuesday);
    }
    if (saveEventDataModel.wednesday) {
      result.add(DateTime.wednesday);
    }
    if (saveEventDataModel.thursday) {
      result.add(DateTime.thursday);
    }
    if (saveEventDataModel.friday) {
      result.add(DateTime.friday);
    }
    if (saveEventDataModel.saturday) {
      result.add(DateTime.saturday);
    }

    return result;
  }

  bool _checkWeekdayInToday(EventDataModel event) {
    var nowWeekday = DateTime.now().weekday;
    if (nowWeekday == DateTime.monday ) {
      return event.monday;
    }
    if (nowWeekday == DateTime.tuesday ) {
      return event.tuesday;
    }
    if (nowWeekday == DateTime.wednesday ) {
      return event.wednesday;
    }
    if (nowWeekday == DateTime.thursday ) {
      return event.thursday;
    }
    if (nowWeekday == DateTime.friday ) {
      return event.friday;
    }
    if (nowWeekday == DateTime.saturday ) {
      return event.saturday;
    }
    if (nowWeekday == DateTime.sunday ) {
      return event.sunday;
    }

    return false;
  }
}
