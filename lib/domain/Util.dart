class Util {
  static int calcTaskTimeExpired(int hour, int minute) {
    return (hour * 100) + minute;
  }

  static int calcTaskDateExpired(int year, int month, int day) {
    return (year * 10000) + (month * 100) + day;
  }

  static int calcTaskDateToday() {
    var now = DateTime.now();
    return calcTaskDateExpired(now.year, now.month, now.day);
  }

  static int getNowUtcMilliseconds() {
    return DateTime
        .now()
        .toUtc()
        .millisecondsSinceEpoch;
  }
}
