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
      final shelfRouterParamsKey = "shelf_router/params";
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

  Map<String, Object>? getValidatedBodyData() {
    final data = context[RequestConstants.VALIDATED_BODY_DATA.value]
        as Map<String, Object>?;

    return data;
  }
}
