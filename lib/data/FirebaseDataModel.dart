import 'package:firebase_database/firebase_database.dart';

class LoginUserFirebaseDataModel {
  String uid;
  String userName;
  String email;

  LoginUserFirebaseDataModel(this.uid, this.userName, this.email);

  LoginUserFirebaseDataModel.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value["uid"],
        userName = snapshot.value["userName"],
        email = snapshot.value["email"];

  toJson() {
    return {
      "uid": uid,
      "userName": userName,
      "email": email,
    };
  }
}

class DailyTaskFirebaseDataModel {
  String id;
  String name;
  int expiredHour;
  int expiredMinute;
  int expiredTime;
  bool enable;
  int enableTimeStart;
  int enableTimeEnd;
  int createdTime;
  int updateTime;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;

  DailyTaskFirebaseDataModel(
      this.name,
      this.expiredHour,
      this.expiredMinute,
      this.expiredTime,
      this.enable,
      this.enableTimeStart,
      this.enableTimeEnd,
      this.createdTime,
      this.updateTime,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday);

  DailyTaskFirebaseDataModel.from(dynamic key, dynamic values)
      : id = key,
        name = values["name"],
        expiredHour = values["expiredHour"],
        expiredMinute = values["expiredMinute"],
        expiredTime = values["expiredTime"],
        enable = values["enable"],
        enableTimeStart = values["enableTimeStart"],
        enableTimeEnd = values["enableTimeEnd"],
        createdTime = values["createdTime"],
        updateTime = values["updateTime"],
        monday = values["monday"],
        tuesday = values["tuesday"],
        wednesday = values["wednesday"],
        thursday = values["thursday"],
        friday = values["friday"],
        saturday = values["saturday"],
        sunday = values["sunday"];

  toJson() {
    return {
      "name": name,
      "expiredHour": expiredHour,
      "expiredMinute": expiredMinute,
      "expiredTime": expiredTime,
      "enable": enable,
      "enableTimeStart": enableTimeStart,
      "enableTimeEnd": enableTimeEnd,
      "createdTime": createdTime,
      "updateTime": updateTime,
      "monday": monday,
      "tuesday": tuesday,
      "wednesday": wednesday,
      "thursday": thursday,
      "friday": friday,
      "saturday": saturday,
      "sunday": sunday,
    };
  }
}

class DailyTaskHistoryFirebaseDataModel {
  String id;
  String eventId;
  String eventName;
  int doneTime;
  int expiredHour;
  int expiredMinute;
  int expiredTime;
  int createdTime;
  int date;
  int status;

  DailyTaskHistoryFirebaseDataModel(
      this.eventId,
      this.eventName,
      this.doneTime,
      this.expiredHour,
      this.expiredMinute,
      this.expiredTime,
      this.createdTime,
      this.date,
      this.status);

  DailyTaskHistoryFirebaseDataModel.from(dynamic key, dynamic values)
      : id = key,
        eventId = values["eventId"],
        eventName = values["eventName"],
        doneTime = values["doneTime"],
        expiredHour = values["expiredHour"],
        expiredMinute = values["expiredMinute"],
        expiredTime = values["expiredTime"],
        createdTime = values["createdTime"],
        date = values["date"],
        status = values["status"];

  toJson() {
    return {
      "eventId": eventId,
      "eventName": eventName,
      "doneTime": doneTime,
      "expiredHour": expiredHour,
      "expiredMinute": expiredMinute,
      "expiredTime": expiredTime,
      "createdTime": createdTime,
      "date": date,
      "status": status,
    };
  }
}

class OneTimeTaskFirebaseDataModel {
  String id;
  String name;
  int expiredHour;
  int expiredMinute;
  int expiredTime;
  int expiredDay;
  int expiredMonth;
  int expiredYear;
  int expiredDate;
  bool enable;
  int enableTimeStart;
  int enableTimeEnd;
  int createdTime;
  int updateTime;

  OneTimeTaskFirebaseDataModel(
    this.name,
    this.expiredHour,
    this.expiredMinute,
    this.expiredTime,
    this.expiredDay,
    this.expiredMonth,
    this.expiredYear,
    this.expiredDate,
    this.enable,
    this.enableTimeStart,
    this.enableTimeEnd,
    this.createdTime,
    this.updateTime,
  );

  OneTimeTaskFirebaseDataModel.from(dynamic key, dynamic values)
      : id = key,
        name = values["name"],
        expiredHour = values["expiredHour"],
        expiredMinute = values["expiredMinute"],
        expiredTime = values["expiredTime"],
        enable = values["enable"],
        enableTimeStart = values["enableTimeStart"],
        enableTimeEnd = values["enableTimeEnd"],
        createdTime = values["createdTime"],
        updateTime = values["updateTime"],
        expiredDay = values["expiredDay"],
        expiredMonth = values["expiredMonth"],
        expiredYear = values["expiredYear"],
        expiredDate = values["expiredDate"];

  toJson() {
    return {
      "name": name,
      "expiredHour": expiredHour,
      "expiredMinute": expiredMinute,
      "expiredTime": expiredTime,
      "enable": enable,
      "enableTimeStart": enableTimeStart,
      "enableTimeEnd": enableTimeEnd,
      "createdTime": createdTime,
      "updateTime": updateTime,
      "expiredDay": expiredDay,
      "expiredMonth": expiredMonth,
      "expiredYear": expiredYear,
      "expiredDate": expiredDate,
    };
  }
}

class OneTimeTaskHistoryFirebaseDataModel {
  String id;
  String oneTimeTaskId;
  String oneTimeTaskName;
  int doneTime;
  int expiredHour;
  int expiredMinute;
  int expiredTime;
  int expiredDay;
  int expiredMonth;
  int expiredYear;
  int expiredDate;
  int createdTime;
  int date;
  int status;
  bool enable;

  OneTimeTaskHistoryFirebaseDataModel(
    this.oneTimeTaskId,
    this.oneTimeTaskName,
    this.doneTime,
    this.expiredHour,
    this.expiredMinute,
    this.expiredTime,
    this.expiredDay,
    this.expiredMonth,
    this.expiredYear,
    this.expiredDate,
    this.createdTime,
    this.date,
    this.status,
    this.enable,
  );

  OneTimeTaskHistoryFirebaseDataModel.from(dynamic key, dynamic values)
      : id = key,
        oneTimeTaskId = values["oneTimeTaskId"],
        oneTimeTaskName = values["oneTimeTaskName"],
        doneTime = values["doneTime"],
        expiredHour = values["expiredHour"],
        expiredMinute = values["expiredMinute"],
        expiredTime = values["expiredTime"],
        createdTime = values["createdTime"],
        date = values["date"],
        status = values["status"],
        expiredDay = values["expiredDay"],
        expiredMonth = values["expiredMonth"],
        expiredYear = values["expiredYear"],
        expiredDate = values["expiredDate"],
        enable = values["enable"];

  toJson() {
    return {
      "oneTimeTaskId": oneTimeTaskId,
      "oneTimeTaskName": oneTimeTaskName,
      "doneTime": doneTime,
      "expiredHour": expiredHour,
      "expiredMinute": expiredMinute,
      "expiredTime": expiredTime,
      "createdTime": createdTime,
      "date": date,
      "status": status,
      "expiredDay": expiredDay,
      "expiredMonth": expiredMonth,
      "expiredYear": expiredYear,
      "expiredDate": expiredDate,
      "enable": enable,
    };
  }
}

class TaskStatusDataConstant {
  static const int STATUS_TODO = 0;
  static const int STATUS_DONE = 1;
  static const int STATUS_DONE_LATE = 2;
}
