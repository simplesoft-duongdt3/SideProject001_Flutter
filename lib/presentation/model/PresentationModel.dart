import 'package:flutter_app/domain/DomainModel.dart';

class LoginUserPresentationModel {
  String _uid;
  String _userName;
  String _email;
  String _qrCodeContent;

  LoginUserPresentationModel(
      this._uid, this._userName, this._email, this._qrCodeContent);

  String get qrCodeContent => _qrCodeContent;

  String get email => _email;

  String get userName => _userName;

  String get uid => _uid;
}

class TodayTodoPresentationModel {
  String _eventId;
  String _historyId;
  String _name;
  int _expiredHour;
  int _expiredMinute;
  TaskStatus _status;
  TaskType _type;

  TodayTodoPresentationModel(this._eventId, this._historyId, this._name,
      this._expiredHour, this._expiredMinute, this._status, this._type);

  TaskType get type => _type;

  TaskStatus get status => _status;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;

  String get historyId => _historyId;

  String get eventId => _eventId;


}

class AddDailyTaskPresentationModel {
  String name;
  int expiredHour;
  int expiredMinute;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;

  bool get isDaily =>
      monday &&
      tuesday &&
      wednesday &&
      thursday &&
      friday &&
      saturday &&
      sunday;

  void applyAllDayOfWeek(bool isAllDayOfWeek) {
    this.monday = isAllDayOfWeek;
    this.tuesday = isAllDayOfWeek;
    this.wednesday = isAllDayOfWeek;
    this.thursday = isAllDayOfWeek;
    this.friday = isAllDayOfWeek;
    this.saturday = isAllDayOfWeek;
    this.sunday = isAllDayOfWeek;
  }

  AddDailyTaskPresentationModel(
    this.name,
    this.expiredHour,
    this.expiredMinute,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  );
}

class AddOneTimeTaskPresentationModel {
  String name;
  int expiredHour;
  int expiredMinute;
  int expiredDay;
  int expiredMonth;
  int expiredYear;

  AddOneTimeTaskPresentationModel(this.name, this.expiredHour,
      this.expiredMinute, this.expiredDay, this.expiredMonth, this.expiredYear);
}

class DailyTaskDetailPresentationModel {
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

  DailyTaskDetailPresentationModel(this._name, this._expiredHour,
      this._expiredMinute, this._monday, this._tuesday, this._wednesday,
      this._thursday, this._friday, this._saturday, this._sunday);

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

class OneTimeTaskDetailPresentationModel {
  String _name;
  int _expiredHour;
  int _expiredMinute;
  int _expiredDay;
  int _expiredMonth;
  int _expiredYear;

  OneTimeTaskDetailPresentationModel(this._name, this._expiredHour,
      this._expiredMinute, this._expiredDay, this._expiredMonth,
      this._expiredYear);

  int get expiredYear => _expiredYear;

  int get expiredMonth => _expiredMonth;

  int get expiredDay => _expiredDay;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;


}

class TaskHistoryPresentationModel {
  String _eventId;
  String _eventName;
  int _doneTime;
  int _expiredHour;
  int _expiredMinute;
  int _createdTime;
  int _expiredDay;
  int _expiredMonth;
  int _expiredYear;
  TaskStatus _status;

  TaskHistoryPresentationModel(this._eventId, this._eventName, this._doneTime,
      this._expiredHour, this._expiredMinute, this._createdTime,
      this._expiredDay, this._expiredMonth, this._expiredYear, this._status);

  TaskStatus get status => _status;

  int get expiredYear => _expiredYear;

  int get expiredMonth => _expiredMonth;

  int get expiredDay => _expiredDay;

  int get createdTime => _createdTime;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  int get doneTime => _doneTime;

  String get eventName => _eventName;

  String get eventId => _eventId;


}

class DailyTaskPresentationModel {
  String _taskId;
  String _name;
  int _expiredHour;
  int _expiredMinute;

  DailyTaskPresentationModel(
      this._taskId, this._name, this._expiredHour, this._expiredMinute);

  String get name => _name;

  String get taskId => _taskId;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;
}

class OneTimeTaskPresentationModel {
  String _taskId;
  String _name;
  int _expiredHour;
  int _expiredMinute;
  int _expiredDay;
  int _expiredMonth;
  int _expiredYear;

  OneTimeTaskPresentationModel(this._taskId, this._name, this._expiredHour,
      this._expiredMinute, this._expiredDay, this._expiredMonth,
      this._expiredYear);

  int get expiredYear => _expiredYear;

  int get expiredMonth => _expiredMonth;

  int get expiredDay => _expiredDay;

  int get expiredMinute => _expiredMinute;

  int get expiredHour => _expiredHour;

  String get name => _name;

  String get taskId => _taskId;


}



class ReceivedFriendRequestPresentationModel {
  String _requestId;
  String _email;
  int _requestTime;
  FriendRequestStatusEnum _status;

  ReceivedFriendRequestPresentationModel(this._requestId, this._email,
      this._requestTime, this._status);

  int get requestTime => _requestTime;

  String get email => _email;

  FriendRequestStatusEnum get status => _status;

  String get requestId => _requestId;

}

class SentFriendRequestPresentationModel {
  String _requestId;
  String _email;
  int _requestTime;
  FriendRequestStatusEnum _status;

  SentFriendRequestPresentationModel(this._requestId, this._email,
      this._requestTime, this._status);

  int get requestTime => _requestTime;

  String get email => _email;

  FriendRequestStatusEnum get status => _status;

  String get requestId => _requestId;


}

class FriendPresentationModel {
  String _uid;
  String _email;

  FriendPresentationModel(this._uid, this._email);

  String get email => _email;

  String get uid => _uid;

}

class FriendRequestPresentationModel {
  String _uid;
  String _email;

  FriendRequestPresentationModel(this._uid, this._email);

  String get email => _email;

  String get uid => _uid;
}