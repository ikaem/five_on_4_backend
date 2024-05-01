enum RegisterWithEmailAndPasswordRequestBodyKeyConstants {
  EMAIL._("email"),
  PASSWORD._("password"),
  FIRST_NAME._("first_name"),
  LAST_NAME._("last_name"),
  NICKNAME._("nickname");

  const RegisterWithEmailAndPasswordRequestBodyKeyConstants._(this.value);
  final String value;
}
