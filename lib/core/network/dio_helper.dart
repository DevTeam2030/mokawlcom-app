import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/custom_interceptors.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';

class DioHelper {
  final Dio _dio;

  DioHelper()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {"Content-Type": "application/json"},
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          receiveDataWhenStatusError: true,
          queryParameters: {"lang": AppConstants.language},
        ),
      ) {
    // Verbose request and response logging is intentionally disabled.
    _dio.interceptors.add(CustomInterceptors());
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.get(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> post({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    void Function(int, int)? onSendProgress,
  }) async {
    //_dio.options.headers = headers;
    return await _dio.post(
      url,
      data: data,
      queryParameters: query,
      options: Options(headers: headers),
      onSendProgress: onSendProgress,
    );
  }

  Future<Response> put({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    //_dio.options.headers = headers;
    return await _dio.put(
      url,
      data: data,
      queryParameters: query,
      // options: Options(headers: headers),
    );
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.delete(
      url,
      data: data,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }

  Future<Response> patch({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.patch(
      url,
      data: data,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }
}
