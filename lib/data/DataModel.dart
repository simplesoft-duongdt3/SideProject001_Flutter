class EventDataModel {
  int id;
  String name;

  //example 18:59
  int expiredHour;
  int expiredMinute;

  //Sunday 1 Mon 2 Sat 7
  List<int> weekdays;

  bool enable;
  int enableTimeStart;
  int enableTimeEnd;
  int createdTime;
  int updateTime;

  EventDataModel(this.id, this.name, this.expiredHour,
      this.expiredMinute, this.weekdays, this.enable, this.enableTimeStart,
      this.enableTimeEnd, this.createdTime, this.updateTime);
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