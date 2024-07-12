extension DateTimeExtension on DateTime {
  DateTime get normalizedToSeconds {
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
    );
  }
}
