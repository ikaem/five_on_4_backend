// TODO maybe better to use abstract classes, becasue they allow for constants?
enum SearchPlayersRequestBodyKeyConstants {
  NAME_TERM._('name_term');

  const SearchPlayersRequestBodyKeyConstants._(this.value);
  final String value;
}
