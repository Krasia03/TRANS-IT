import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: ApiConfig.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: jsonEncode(data));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(String url, {dynamic data}) async {
    try {
      final response = await _dio.put(url, data: jsonEncode(data));
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map) {
        return {'success': true, 'data': response.data};
      }
      return {'success': true, 'data': response.data};
    }
    return {
      'success': false,
      'message': 'Request failed with status: ${response.statusCode}',
    };
  }

  Map<String, dynamic> _handleError(DioException e) {
    String message = 'An error occurred';
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server took too long to respond. Please try again.';
        break;
      case DioExceptionType.badResponse:
        message = e.response?.data?['message'] ?? 'Server error occurred';
        break;
      case DioExceptionType.connectionError:
        message = 'Unable to connect to server. Please check your internet.';
        break;
      default:
        message = 'Something went wrong. Please try again.';
    }

    return {
      'success': false,
      'message': message,
    };
  }

  // Store auth token
  Future<void> setToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Remove auth token
  Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
