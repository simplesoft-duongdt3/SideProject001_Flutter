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
  String eventId;
  String historyId;
  String name;
  int expiredHour;
  int expiredMinute;
  TaskStatus status;
  TaskType type;

  TodayTodoPresentationModel(
    this.eventId,
    this.historyId,
    this.name,
    this.expiredHour,
    this.expiredMinute,
    this.status,
    this.type,
  );
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

  AddOneTimeTaskPresentationModel(
    this.name,
    this.expiredHour,
    this.expiredMinute,
    this.expiredDay,
    this.expiredMonth,
    this.expiredYear,
  );
}

class DailyTaskDetailPresentationModel {
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

  DailyTaskDetailPresentationModel(
      this.name,
      this.expiredHour,
      this.expiredMinute,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday);
}

class OneTimeTaskDetailPresentationModel {
  String name;
  int expiredHour;
  int expiredMinute;
  int expiredDay;
  int expiredMonth;
  int expiredYear;

  OneTimeTaskDetailPresentationModel(this.name, this.expiredHour,
      this.expiredMinute, this.expiredDay, this.expiredMonth, this.expiredYear);

}

class TaskHistoryPresentationModel {
  String eventId;
  String eventName;
  int doneTime;
  int expiredHour;
  int expiredMinute;
  int createdTime;
  TaskStatus status;

  TaskHistoryPresentationModel(this.eventId, this.eventName, this.doneTime,
      this.expiredHour, this.expiredMinute, this.createdTime, this.status);
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
