enum JwtDurationConstants {
  ACCESS_TOKEN_DURATION._(Duration(minutes: 15)),
  REFRESH_TOKEN_DURATION._(Duration(days: 7));

  const JwtDurationConstants._(this.value);
  final Duration value;
}
