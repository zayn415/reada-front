import 'dart:io';

import 'package:dio/dio.dart';
import 'package:reada/constants/api_prefix.dart';

class ApiClient {
  final Dio _dio;
  final String Function() _getToken;
  final String _baseUrl = 'http://10.0.2.2:8080';

  ApiClient(this._dio, this._getToken) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.interceptors.add(LogInterceptor(requestBody: true));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!options.path.endsWith(ApiPrefix.code) &&
              !options.path.endsWith(ApiPrefix.login)) {
            final token = _getToken();
            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
      ),
    );
  }

  // 处理异常
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.sendTimeout:
        return '请求超时';
      case DioExceptionType.receiveTimeout:
        return '接收超时';
      case DioExceptionType.badResponse:
        return '服务器响应错误: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return '请求被取消';
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return '网络连接失败，请检查网络设置';
        }
        return '未知错误';
      default:
        return '未知错误';
    }
  }

  // POST请求
  Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception('返回数据格式错误');
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
}
