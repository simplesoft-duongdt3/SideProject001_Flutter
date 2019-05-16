import 'package:flutter_app/domain/DomainModel.dart';

class EventPresentationModel {
  int eventId;
  int historyId;
  String name;
  int expiredHour;
  int expiredMinute;
  TaskStatus status;

  EventPresentationModel(this.eventId, this.historyId, this.name, this.expiredHour, this.expiredMinute, this.status);
}

class AddEventPresentationModel {
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

  AddEventPresentationModel(this.name, this.expiredHour,
      this.expiredMinute, this.monday, this.tuesday, this.wednesday,
      this.thursday, this.friday, this.saturday, this.sunday);
}

class TaskHistoryPresentationModel {
  int eventId;
  String eventName;
  int doneTime;
  int expiredHour;
  int expiredMinute;
  int createdTime;
  TaskStatus status;

  TaskHistoryPresentationModel(this.eventId, this.eventName, this.doneTime,
      this.expiredHour, this.expiredMinute, this.createdTime,
      this.status);


}