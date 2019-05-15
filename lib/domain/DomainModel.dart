import 'dart:core';

class EventDomainModel {
  int _eventId;
  int _historyId;
  String _name;
  int _expiredHour;
  int _expiredMinute;
  TaskStatus _status;

  EventDomainModel(
      this._eventId, this._historyId, this._name, this._expiredHour, this._expiredMinute, this._status
      );

  String get name => _name;

  int get eventId => _eventId;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  int get historyId => _historyId;

  TaskStatus get status => _status;
}

enum TaskStatus {
  TODO,
  DONE,
  OUT_OF_TIME
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
  int _historyId;

  DoneEventDomainModel(this._eventId, this._historyId);

  int get eventId => _eventId;

  int get historyId => _historyId;


}

class EventHistoryDomainModel {
  int _eventId;
  String _eventName;
  int _doneTime;
  int _expiredHour;
  int _expiredMinute;
  int _createdTime;
  TaskStatus _status;

  EventHistoryDomainModel(this._eventId, this._eventName, this._doneTime,
      this._expiredHour, this._expiredMinute, this._createdTime,
      this._status);

  TaskStatus get status => _status;

  int get createdTime => _createdTime;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  int get doneTime => _doneTime;

  String get eventName => _eventName;

  int get eventId => _eventId;

}

class EventHistoryStatus {

}

enum ReportTimeEnum {
  TODAY,
  YESTERDAY,
  THIS_WEEK,
  LAST_WEEK,
}

