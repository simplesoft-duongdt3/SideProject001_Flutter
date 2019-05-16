import 'package:flutter_app/domain/Util.dart';

class EventDataModel {
  int id;
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

  EventDataModel(this.id,
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
}

class EventHistoryDataModel {
  int id;
  int eventId;
  String eventName;
  int doneTime;
  int expiredHour;
  int expiredMinute;
  int expiredTime;
  int createdTime;
  int date;
  int status;

  EventHistoryDataModel(this.id,
      this.eventId,
      this.eventName,
      this.doneTime,
      this.expiredHour,
      this.expiredMinute,
      this.expiredTime,
      this.createdTime,
      this.date,
      this.status);

  static const int STATUS_TODO = 0;
  static const int STATUS_DONE = 1;
  static const int STATUS_DONE_LATE = 2;
}
