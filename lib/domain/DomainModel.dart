import 'dart:core';

class EventDomainModel {
  int _id;
  String _name;
  //example 18:59
  int _expiredHour;
  int _expiredMinute;
  //Sunday 1 Mon 2 Sat 7
  List<int> _weekdays;

  EventDomainModel(this._id, this._name, this._expiredHour,
      this._expiredMinute, this._weekdays);

  List<int> get weekdays => _weekdays;

  String get name => _name;

  int get id => _id;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

}

class SaveEventDomainModel {
  String _name;
  //example 18:59
  int _expiredHour;
  int _expiredMinute;
  //Sunday 1 Mon 2 Sat 7
  List<int> _weekdays;

  SaveEventDomainModel(this._name, this._expiredHour, this._weekdays);

  List<int> get weekdays => _weekdays;


  int get expiredHour => _expiredHour;

  String get name => _name;

  int get expiredMinute => _expiredMinute;
}

class DisableEventDomainModel {
  int _eventId;

  DisableEventDomainModel(this._eventId);

  int get eventId => _eventId;
}

class DoneEventDomainModel {
  int _eventId;

  DoneEventDomainModel(this._eventId);

  int get eventId => _eventId;
}

class EventHistoryDomainModel {
  int eventId;
  String eventName;
  bool isDone;
  int doneTime;
  int expiredHourMinute;
  int expiredMinute;
  int createdTime;
}

enum ReportTimeEnum {
  TODAY,
  YESTERDAY,
  THIS_WEEK,
  LAST_WEEK,
  THIS_MONTH,
  LAST_MONTH
}