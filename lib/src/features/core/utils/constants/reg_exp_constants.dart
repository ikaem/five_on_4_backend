enum RegExpConstants {
  // TODO find better regex
  EMAIL._(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
  LETTERS_AND_NUMBERS._(r'^(?=.*\d)(?=.*[a-zA-Z]).+$');

  const RegExpConstants._(this.value);
  final String value;
}
