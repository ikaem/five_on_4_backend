import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

import '../constants/request_constants.dart';

extension RequestExtension on Request {
  Future<Map<String, dynamic>> parseBody() async {
    try {
      final bodyString = await readAsString();
      return jsonDecode(bodyString);
    } catch (e) {
      log(
        "Error parsing body: $e",
        name: "RequestExtension",
      );
      return {};
    }
  }

  T? getUrlParam<T>({
    required String paramName,
    required T? Function(String value) parser,
  }) {
    try {
      // TODO why not using request.params here?
      final shelfRouterParamsKey = "shelf_router/params";
      // TODO where is this context coming from?
      final paramsMap = context[shelfRouterParamsKey] as Map<String, String>;

      final paramValue = paramsMap[paramName];
      if (paramValue is! String) {
        return null;
      }

      final parsedValue = parser(paramValue);

      return parsedValue;
    } catch (e) {
      log("Error in getting url param: $e", name: "RequestExtension");

      return null;
    }
  }

  Request getChangedRequestWithValidatedBodyData(Map<String, Object?> data) {
    final changedRequest = change(
      context: {
        RequestConstants.VALIDATED_BODY_DATA.value: data,
      },
    );

    return changedRequest;
  }

  // NOTE: this copies current request, and adding validated url query params to the context
  Request getChangedRequestWithValidatedUrlQueryParams(
      Map<String, Object?> data) {
    final changedRequest = change(
      context: {
        RequestConstants.VALIDATED_URL_QUERY_PARAMS.value: data,
      },
    );

    return changedRequest;
  }

  Map<String, dynamic>? getValidatedBodyData() {
    final data = context[RequestConstants.VALIDATED_BODY_DATA.value]
        as Map<String, dynamic>?;

    return data;
  }

  Map<String, dynamic>? getValidatedUrlQueryParams() {
    final data = context[RequestConstants.VALIDATED_URL_QUERY_PARAMS.value]
        as Map<String, dynamic>?;

    return data;
  }
}
