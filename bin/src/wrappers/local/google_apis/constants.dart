part of "google_apis_wrapper.dart";

enum GoogleApisHttpConstants {
  BASE_URL("www.googleapis.com"),
  OAUTH_API_CONTEXT_PATH("oauth2/v3"),
  OAUTH_TOKEN_INFO_API_ENDPOINT_PATH("tokeninfo");

  // v1("https://www.googleapis.com/oauth2/v1/tokeninfo"),
  // v3("https://www.googleapis.com/oauth2/v3/tokeninfo");

  const GoogleApisHttpConstants(this.value);
  final String value;
}
