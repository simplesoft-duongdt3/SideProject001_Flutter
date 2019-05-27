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

class DailyTaskDomainModel {
  String _taskId;
  String _name;
  int _expiredHour;
  int _expiredMinute;

  DailyTaskDomainModel(
      this._taskId, this._name, this._expiredHour, this._expiredMinute);

  String get name => _name;

  String get taskId => _taskId;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;
}

class OneTimeTaskDomainModel {
  String _taskId;
  String _name;
  int _expiredHour;
  int _expiredMinute;
  int _expiredDay;
  int _expiredMonth;
  int _expiredYear;

  OneTimeTaskDomainModel(this._taskId,
      this._name,
      this._expiredHour,
      this._expiredMinute,
      this._expiredDay,
      this._expiredMonth,
      this._expiredYear);

  int get expiredYear => _expiredYear;

  int get expiredMonth => _expiredMonth;

  int get expiredDay => _expiredDay;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;

  String get taskId => _taskId;
}

class TodayTodoDomainModel {
  String _eventId;
  String _historyId;
  String _name;
  int _expiredHour;
  int _expiredMinute;
  TaskStatus _status;
  TaskType _type;

  TodayTodoDomainModel(
    this._eventId,
    this._historyId,
    this._name,
    this._expiredHour,
    this._expiredMinute,
    this._status,
    this._type,
  );

  String get name => _name;

  String get eventId => _eventId;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get historyId => _historyId;

  TaskStatus get status => _status;

  TaskType get type => _type;
}

enum TaskType {
  DAILY,
  ONE_TIME,
}
enum TaskStatus {
  TODO,
  DONE,
  DONE_LATE,
}

class SaveDailyTaskDomainModel {
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

  SaveDailyTaskDomainModel(
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

class SaveOneTimeTaskDomainModel {
  String _name;
  int _expiredHour;
  int _expiredMinute;
  int _expiredDay;
  int _expiredMonth;
  int _expiredYear;

  SaveOneTimeTaskDomainModel(
    this._name,
    this._expiredHour,
    this._expiredMinute,
    this._expiredDay,
    this._expiredMonth,
    this._expiredYear,
  );

  int get expiredYear => _expiredYear;

  int get expiredMonth => _expiredMonth;

  int get expiredDay => _expiredDay;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;
}

class OneTimeTaskDetailDomainModel {
  String _name;
  int _expiredHour;
  int _expiredMinute;
  int _expiredDay;
  int _expiredMonth;
  int _expiredYear;

  OneTimeTaskDetailDomainModel(this._name,
      this._expiredHour,
      this._expiredMinute,
      this._expiredDay,
      this._expiredMonth,
      this._expiredYear);

  int get expiredYear => _expiredYear;

  int get expiredMonth => _expiredMonth;

  int get expiredDay => _expiredDay;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;
}

class DailyTaskDetailDomainModel {
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

  DailyTaskDetailDomainModel(
    this._name,
    this._expiredHour,
    this._expiredMinute,
    this._monday,
    this._tuesday,
    this._wednesday,
    this._thursday,
    this._friday,
    this._saturday,
    this._sunday,
  );

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

class DisableDailyTaskDomainModel {
  String _eventId;

  DisableDailyTaskDomainModel(this._eventId);

  String get eventId => _eventId;
}

class DisableOneTimeTaskDomainModel {
  String _oneTimeEventId;

  DisableOneTimeTaskDomainModel(this._oneTimeEventId);

  String get oneTimeEventId => _oneTimeEventId;
}

class DoneDailyTaskDomainModel {
  String _eventId;
  String _historyId;

  DoneDailyTaskDomainModel(this._eventId, this._historyId);

  String get eventId => _eventId;

  String get historyId => _historyId;
}

class DoneOneTimeTaskDomainModel {
  String _eventId;
  String _historyId;

  DoneOneTimeTaskDomainModel(this._eventId, this._historyId);

  String get eventId => _eventId;

  String get historyId => _historyId;
}

class TaskHistoryDomainModel {
  String eventId;
  String eventName;
  int expiredTime;
  int doneTime;
  int date;
  int expiredHour;
  int expiredMinute;
  int createdTime;
  int expiredDay;
  int expiredMonth;
  int expiredYear;
  TaskStatus status;

  TaskHistoryDomainModel(this.eventId, this.eventName, this.expiredTime,
      this.doneTime, this.date,
      this.expiredHour, this.expiredMinute, this.createdTime, this.expiredDay,
      this.expiredMonth, this.expiredYear, this.status);
}

class EventHistoryStatus {}

enum ReportTimeEnum {
  TODAY,
  YESTERDAY,
  THIS_WEEK,
  LAST_WEEK,
}
enum FriendRequestStatusEnum {
  STATUS_SENT,
  STATUS_ACCEPT,
  STATUS_DENY
}

class FriendRequestDomainModel {
  String _uid;
  String _userName;
  String _email;
  String _requestTime;
  FriendRequestStatusEnum _status;

  FriendRequestDomainModel(this._uid, this._userName, this._email,
      this._requestTime, this._status);

  String get requestTime => _requestTime;

  String get email => _email;

  String get userName => _userName;

  String get uid => _uid;

  FriendRequestStatusEnum get status => _status;

}

class ReceivedFriendRequestDomainModel {
  String _email;
  int _requestTime;
  FriendRequestStatusEnum _status;

  ReceivedFriendRequestDomainModel(this._email,
      this._requestTime, this._status);

  int get requestTime => _requestTime;

  String get email => _email;

  FriendRequestStatusEnum get status => _status;

}

class SendFriendRequestDomainModel {
  String _email;
  int _requestTime;
  FriendRequestStatusEnum _status;

  SendFriendRequestDomainModel(this._email,
      this._requestTime, this._status);

  int get requestTime => _requestTime;

  String get email => _email;

  FriendRequestStatusEnum get status => _status;

}

class FriendDomainModel {
  String _uid;
  String _userName;

  FriendDomainModel(this._uid, this._userName);

  String get userName => _userName;

  String get uid => _uid;

}

class AcceptFriendRequestDomainModel {
  String _requestUid;

  AcceptFriendRequestDomainModel(this._requestUid);

  String get requestUid => _requestUid;
}