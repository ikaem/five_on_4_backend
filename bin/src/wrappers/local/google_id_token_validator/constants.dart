part of "google_id_token_validator_wrapper.dart";

enum HttpConstants {
  v1("https://www.googleapis.com/oauth2/v1/tokeninfo"),
  v3("https://www.googleapis.com/oauth2/v3/tokeninfo");

  const HttpConstants(this.value);
  final String value;
}
