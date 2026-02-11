import '../models/user.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _api.post(
      ApiConfig.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response['success'] && response['data'] != null) {
      final data = response['data'];
      if (data['token'] != null) {
        await _api.setToken(data['token']);
      }
      if (data['user'] != null) {
        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'message': 'Login successful',
        };
      }
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Login failed',
    };
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _api.post(
      ApiConfig.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': 'customer',
        'status': 'active',
      },
    );

    if (response['success']) {
      return {
        'success': true,
        'message': 'Registration successful. Please login.',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Registration failed',
    };
  }

  Future<Map<String, dynamic>> getProfile(int userId) async {
    final response = await _api.get('${ApiConfig.getProfile}&id=$userId');

    if (response['success'] && response['data'] != null) {
      return {
        'success': true,
        'user': User.fromJson(response['data']),
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to fetch profile',
    };
  }

  Future<Map<String, dynamic>> updateProfile(User user) async {
    final response = await _api.put(
      '${ApiConfig.updateProfile}&id=${user.id}',
      data: user.toJson(),
    );

    if (response['success']) {
      return {
        'success': true,
        'message': 'Profile updated successfully',
      };
    }
    return {
      'success': false,
      'message': response['message'] ?? 'Failed to update profile',
    };
  }

  Future<void> logout() async {
    await _api.removeToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _api.getToken();
    return token != null;
  }
}
