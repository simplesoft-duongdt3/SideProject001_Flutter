import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';

import 'DataModel.dart';

class EventRepositoryImpl implements EventRepository {
  static List<EventDataModel> databaseEventFake = [];
  static List<EventHistoryDataModel> databaseHistoryFake = [];

  @override
  Future<void> createEvent(SaveEventDomainModel saveEventDataModel) async {
    int nextItemId = _getTaskNextItemId();
    bool defaultEventEnable = true;
    var nowMilliseconds = _getNowMilliseconds();
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

  int _getTaskNextItemId() {
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

  int _getHistoryNextItemId() {
    int nextItemId = 0;
    var lastItem = databaseHistoryFake.isEmpty
        ? null
        : databaseHistoryFake[databaseHistoryFake.length - 1];
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
    var findEvent =
        databaseEventFake.firstWhere(checkCurrentEventId, orElse: () => null);
    if (findEvent != null) {
      var nowMilliseconds = _getNowMilliseconds();
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
      var nowMilliseconds = _getNowMilliseconds();
      findHistory.doneTime = nowMilliseconds;
      findHistory.status = EventHistoryDataModel.STATUS_DONE;
    }
  }

  @override
  Future<List<EventHistoryDomainModel>> getEventHistoryReport(
      ReportTimeEnum reportTimeEnum) async {
    List<int> dateValues = _getReportDateValues(reportTimeEnum);
    return databaseHistoryFake
        .where((history) => dateValues.contains(history.date))
        .map((history) => _mapHistory(history))
        .toList(growable: false);
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
      var history = todayHistoryModels.firstWhere(
          (history) => history.eventId == task.id,
          orElse: () => null);
      if (history != null) {
        isCreateHistory = false;
      }

      if (isCreateHistory) {
        _createHistory(task, dateValue);
      }
    }
  }

  void _createHistory(EventDataModel task, int dateValue) {
    var nowMilliseconds = _getNowMilliseconds();
    var doneTime = nowMilliseconds;
    var createdTime = nowMilliseconds;

    int id = _getHistoryNextItemId();
    EventHistoryDataModel eventHistoryDataModel = EventHistoryDataModel(
      id,
      task.id,
      task.name,
      doneTime,
      task.expiredHour,
      task.expiredMinute,
      createdTime,
      dateValue,
      EventHistoryDataModel.STATUS_TODO,
    );
    databaseHistoryFake.add(eventHistoryDataModel);
  }

  int _getDateValueToday() {
    var now = DateTime.now();
    int dateValue = _getDateValue(now);
    return dateValue;
  }

  int _getDateValue(DateTime dateSelect) {
    var utcDateTime = dateSelect.toUtc();
    var year = utcDateTime.year;
    var month = utcDateTime.month;
    var date = utcDateTime.day;
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

  List<int> _getReportDateValues(ReportTimeEnum reportTimeEnum) {
    List<int> dateValues = [];

    var now = DateTime.now();
    switch (reportTimeEnum) {
      case ReportTimeEnum.TODAY:
        dateValues.add(_getDateValueToday());
        break;
      case ReportTimeEnum.YESTERDAY:
        DateTime dateSelect = now.subtract(Duration(days: 1));
        dateValues.add(_getDateValue(dateSelect));
        break;
      case ReportTimeEnum.THIS_WEEK:
        DateTime startWeek = now.subtract(Duration(days: now.weekday - 1));
        int i = 0;
        do {
          DateTime dateSelect = startWeek.add(Duration(days: i));
          var dateValue = _getDateValue(dateSelect);
          dateValues.add(dateValue);
          i++;
        } while (i <= 6);
        break;
      case ReportTimeEnum.LAST_WEEK:
        DateTime startCurrentWeek =
            now.subtract(Duration(days: now.weekday - 1));
        DateTime startLastWeek = startCurrentWeek.subtract(Duration(days: 7));
        int i = 0;
        do {
          DateTime dateSelect = startLastWeek.add(Duration(days: i));
          var dateValue = _getDateValue(dateSelect);
          dateValues.add(dateValue);
          i++;
        } while (i <= 6);
        break;
    }
    return dateValues;
  }

  EventHistoryDomainModel _mapHistory(EventHistoryDataModel history) {
    return EventHistoryDomainModel(
        history.eventId,
        history.eventName,
        history.doneTime,
        history.expiredHour,
        history.expiredMinute,
        history.createdTime,
        _mapStatus(history.status));
  }

  int _getNowMilliseconds() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }
}
