import 'package:equatable/equatable.dart';

import '../../utils/constants/http_methods_constants.dart';

class HttpRequestUriPartsValue extends Equatable {
  const HttpRequestUriPartsValue({
    required this.apiUrlScheme,
    required this.apiBaseUrl,
    required this.apiContextPath,
    required this.apiEndpointPath,
    required this.queryParameters,
    // required this.port,
  });

  final String apiUrlScheme;
  final String apiBaseUrl;
  final String apiContextPath;
  final String apiEndpointPath;
  final Map<String, String>? queryParameters;
  // final int? port;

  @override
  // TODO: implement props
  List<Object?> get props => [
        apiUrlScheme,
        apiBaseUrl,
        apiContextPath,
        apiEndpointPath,
        queryParameters,
        // port,
      ];
}

class HttpRequestArgsValue extends Equatable {
  const HttpRequestArgsValue({
    required this.uri,
    required this.method,
    this.data,
  });

  final Uri uri;
  final HttpMethodConstants method;
  final Object? data;

  @override
  List<Object?> get props => [
        uri,
        method,
        data,
      ];
}
