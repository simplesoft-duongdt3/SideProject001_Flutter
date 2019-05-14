class EventDataModel {
  int id;
  String name;
  int expiredHour;
  int expiredMinute;
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

  EventDataModel(this.id, this.name, this.expiredHour, this.expiredMinute,
      this.enable, this.enableTimeStart, this.enableTimeEnd, this.createdTime,
      this.updateTime, this.monday, this.tuesday, this.wednesday, this.thursday,
      this.friday, this.saturday, this.sunday);

}


class EventHistoryDataModel {
  int eventId;
  String eventName;
  bool isDone;
  int doneTime;
  int expiredHour;
  int expiredMinute;
  int createdTime;

  EventHistoryDataModel(this.eventId, this.eventName, this.isDone,
      this.doneTime, this.expiredHour, this.expiredMinute,
      this.createdTime);
}