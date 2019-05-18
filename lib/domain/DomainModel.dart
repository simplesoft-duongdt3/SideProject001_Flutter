import 'dart:core';

class LoginUserDomainModel {
  String _uid;
  String _userName;
  String _email;

  LoginUserDomainModel(this._uid, this._userName, this._email);

  String get email => _email;

  String get userName => _userName;

  String get uid => _uid;

  String getQrCodeContent() {
    return "$_uid|$_userName|$_email";
  }

  LoginUserDomainModel.fromQrCodeContent(String qrCodeContent) {
    var content = qrCodeContent.split("|");
    _uid = content[0];
    _userName = content[1];
    _email = content[2];
  }
}

class TaskDomainModel {
  String _taskId;
  String _name;
  int _expiredHour;
  int _expiredMinute;

  TaskDomainModel(this._taskId, this._name, this._expiredHour,
      this._expiredMinute);

  String get name => _name;

  String get taskId => _taskId;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;
}

class TodayTodoDomainModel {
  String _eventId;
  String _historyId;
  String _name;
  int _expiredHour;
  int _expiredMinute;
  TaskStatus _status;

  TodayTodoDomainModel(this._eventId, this._historyId, this._name,
      this._expiredHour, this._expiredMinute, this._status);

  String get name => _name;

  String get eventId => _eventId;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get historyId => _historyId;

  TaskStatus get status => _status;
}

enum TaskStatus { TODO, DONE, DONE_LATE }

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
  String _eventId;

  DisableEventDomainModel(this._eventId);

  String get eventId => _eventId;
}

class DoneEventDomainModel {
  String _eventId;
  String _historyId;

  DoneEventDomainModel(this._eventId, this._historyId);

  String get eventId => _eventId;

  String get historyId => _historyId;
}

class EventHistoryDomainModel {
  String _eventId;
  String _eventName;
  int _doneTime;
  int _expiredHour;
  int _expiredMinute;
  int _createdTime;
  TaskStatus _status;

  EventHistoryDomainModel(this._eventId, this._eventName, this._doneTime,
      this._expiredHour, this._expiredMinute, this._createdTime, this._status);

  TaskStatus get status => _status;

  int get createdTime => _createdTime;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  int get doneTime => _doneTime;

  String get eventName => _eventName;

  String get eventId => _eventId;
}

class EventHistoryStatus {}

enum ReportTimeEnum { LAST_WEEK, YESTERDAY, TODAY }
