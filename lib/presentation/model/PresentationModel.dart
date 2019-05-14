class EventPresentationModel {
  int id;
  String name;
  int expiredHour;
  int expiredMinute;

  EventPresentationModel(this.id, this.name, this.expiredHour, this.expiredMinute);
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