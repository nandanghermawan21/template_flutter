class Dates {
  static int convert = 1000;

  static DateTime fromEpoch(int e) {
    return DateTime.fromMillisecondsSinceEpoch(e * convert);
  }

  static int toEpoch(DateTime? dateTime) {
    int? e = dateTime?.millisecondsSinceEpoch;
    return e! ~/ convert;
  }

  static DateTime parseUtc(String stringDate) {
    DateTime date = DateTime.parse(stringDate);

    return DateTime.utc(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}