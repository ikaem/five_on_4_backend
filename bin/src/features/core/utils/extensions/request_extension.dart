import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

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
}
