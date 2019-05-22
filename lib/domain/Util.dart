class Util {
  static int calcTaskTimeExpired(int hour, int minute) {
    return (hour * 100) + minute;
  }

  static int calcTaskDateExpired(int year, int month, int day) {
    return (year * 10000) + (month * 100) + day;
  }
}
