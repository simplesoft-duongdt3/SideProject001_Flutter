import 'dart:core';

class EventDomainModel {
  int _id;
  String _name;

  //example 18:59
  int _expiredHour;
  int _expiredMinute;

  EventDomainModel(
      this._id, this._name, this._expiredHour, this._expiredMinute);

  String get name => _name;

  int get id => _id;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;
}

class SaveEventDomainModel {
  String _name;
  int _expiredHour;
  int _expiredMinute;
  bool _monday;
  bool _tuesday;
  bool _wednesday;
  bool _thursday;
  bool _friday;
  bool _saturday;
  bool _sunday;

  SaveEventDomainModel(
      this._name,
      this._expiredHour,
      this._expiredMinute,
      this._monday,
      this._tuesday,
      this._wednesday,
      this._thursday,
      this._friday,
      this._saturday,
      this._sunday);

  bool get sunday => _sunday;

  bool get saturday => _saturday;

  bool get friday => _friday;

  bool get thursday => _thursday;

  bool get wednesday => _wednesday;

  bool get tuesday => _tuesday;

  bool get monday => _monday;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;
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
