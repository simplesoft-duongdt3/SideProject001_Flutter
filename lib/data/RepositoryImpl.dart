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
        saveEventDataModel.sunday);

    databaseEventFake.add(eventDataModel);
  }

  int _getNextItemId() {
    int nextItemId = 0;
    var lastItem = databaseEventFake.isEmpty
        ? null
        : databaseEventFake[databaseEventFake.length - 1];
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
        (event) => event.eventId == disableEventDataModel.eventId;
    var findEvent = databaseEventFake.firstWhere(checkCurrentEventId, orElse: () => null);
    if (findEvent != null) {
      var nowMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
      findEvent.enable = false;
      findEvent.enableTimeEnd = nowMilliseconds;
      findEvent.updateTime = nowMilliseconds;
    }
  }

  @override
  Future<void> doneEvent(DoneEventDomainModel doneEventDomainModel) async {
    var findHistory = databaseHistoryFake.firstWhere(
        (history) => history.id == doneEventDomainModel.historyId,
        orElse: () => null);
    if (findHistory != null) {
      findHistory.status = EventHistoryDataModel.STATUS_DONE;
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
    await _createTodayHistoryEventsIfNeed();

    var dateValueToday = _getDateValueToday();
    List<EventDomainModel> matchedEvents = databaseHistoryFake
        .where((history) => history.date == dateValueToday)
        .map((eventDataModel) => _mapEventDataToEventDomain(eventDataModel))
        .toList(growable: true);
    return matchedEvents;
  }

  EventDomainModel _mapEventDataToEventDomain(
      EventHistoryDataModel historyModel) {
    return EventDomainModel(
        historyModel.eventId,
        historyModel.id,
        historyModel.eventName,
        historyModel.expiredHour,
        historyModel.expiredMinute,
        _mapStatus(historyModel.status));
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
    if (nowWeekday == DateTime.monday) {
      return event.monday;
    }
    if (nowWeekday == DateTime.tuesday) {
      return event.tuesday;
    }
    if (nowWeekday == DateTime.wednesday) {
      return event.wednesday;
    }
    if (nowWeekday == DateTime.thursday) {
      return event.thursday;
    }
    if (nowWeekday == DateTime.friday) {
      return event.friday;
    }
    if (nowWeekday == DateTime.saturday) {
      return event.saturday;
    }
    if (nowWeekday == DateTime.sunday) {
      return event.sunday;
    }

    return false;
  }

  Future<void> _createTodayHistoryEventsIfNeed() async {
    List<EventDataModel> matchedTasks = databaseEventFake
        .where((event) => event.enable && _checkWeekdayInToday(event))
        .toList(growable: true);
    int dateValue = _getDateValueToday();

    var listOfTaskId = [for (var task in matchedTasks) task.id];

    List<EventHistoryDataModel> todayHistoryModels =
        _findTodayHistoryModels(listOfTaskId, dateValue);
    for (var task in matchedTasks) {
      bool isCreateHistory = true;
      var history = todayHistoryModels
          .firstWhere((history) => history.eventId == task.id, orElse: () => null);
      if (history != null) {
        isCreateHistory = false;
      }

      if (isCreateHistory) {
        _createHistory(task, dateValue);
      }
    }
  }

  void _createHistory(EventDataModel task, int dateValue) {
    var nowMilliseconds = DateTime.now().toUtc().millisecondsSinceEpoch;
    var doneTime = nowMilliseconds;
    var createdTime = nowMilliseconds;
    bool isDone = true;
    EventHistoryDataModel eventHistoryDataModel = EventHistoryDataModel(
      task.id,
      task.name,
      isDone,
      doneTime,
      task.expiredHour,
      task.expiredMinute,
      createdTime,
      dateValue,
    );
    databaseHistoryFake.add(eventHistoryDataModel);
  }

  int _getDateValueToday() {
    var now = DateTime.now();
    var year = now.year;
    var month = now.month;
    var date = now.day;
    int dateValue = (year * 10000) + (month * 100) + date;
    return dateValue;
  }

  List<EventHistoryDataModel> _findTodayHistoryModels(
      List<int> listOfTaskId, int dateValue) {
    return databaseHistoryFake
        .where((history) =>
            history.date == dateValue && listOfTaskId.contains(history.eventId))
        .toList(growable: true);
  }

  TaskStatus _mapStatus(int status) {
    if (status == EventHistoryDataModel.STATUS_DONE) {
      return TaskStatus.DONE;
    } else if (status == EventHistoryDataModel.STATUS_OUT_OF_TIME) {
      return TaskStatus.OUT_OF_TIME;
    } else {
      return TaskStatus.TODO;
    }
  }
}
