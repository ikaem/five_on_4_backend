enum RequestConstants {
  VALIDATED_BODY_DATA._("validatedBodyData"),
  // TODO - NEED _DATA IN THE END OF BOTH KEY AND VALUE
  VALIDATED_URL_QUERY_PARAMS._("validatedUrlQueryParams"),
  VALIDATED_URL_PARAMETERS_DATA._("validatedUrlParametersData");

  const RequestConstants._(this.value);
  final String value;
}
