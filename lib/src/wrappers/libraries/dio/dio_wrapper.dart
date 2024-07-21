import 'package:dio/dio.dart';

import '../../../features/core/domain/values/http_request_value.dart';
import '../../../features/core/utils/constants/http_methods_constants.dart';

class DioWrapper {
  const DioWrapper({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<T> get<T>({
    required HttpRequestUriPartsValue uriParts,
  }) async {
    final uri = Uri(
      // port: uriParts.port,
      scheme: uriParts.apiUrlScheme,
      host: uriParts.apiBaseUrl,
      path: '${uriParts.apiContextPath}/${uriParts.apiEndpointPath}',
      queryParameters: uriParts.queryParameters,
    );

    final args = HttpRequestArgsValue(
      uri: uri,
      method: HttpMethodConstants.get,
    );

    final response = await _makeRequest<T>(
      args: args,
    );

    final data = response.data;

    if (data == null) {
      throw Exception(response.statusMessage ?? 'Data not found');
    }

    return data;
  }

  Future<Response<T>> _makeRequest<T>({
    required HttpRequestArgsValue args,
  }) async {
    try {
      final response = await _dio.requestUri<T>(
        args.uri,
        // Uri.parse("localhost:3000/matches"),
        data: args.data,
        options: Options(
          method: args.method.name,
        ),
      );

      if (response.statusCode != 200) {
        // TODO temp
        // ignore: only_throw_errors
        throw 'Invalid response';
      }

      return response;
    } catch (e) {
      final fallbackMesage = 'Failed to make request: $e';

      if (e is DioException) {
        throw Exception(e.response?.statusMessage ?? fallbackMesage);
      }

      throw Exception(fallbackMesage);
    }
  }
}
