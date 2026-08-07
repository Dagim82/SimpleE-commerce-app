import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['token'] as String;
    }

    if (response.statusCode == 401) {
      throw const ApiException('Invalid username or password');
    }

    throw ApiException('Server error (${response.statusCode})');
  }

  Future<User> fetchUserByUsername(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode != 200) {
      throw ApiException('Could not load user data (${response.statusCode})');
    }

    final users = jsonDecode(response.body) as List<dynamic>;
    for (final item in users) {
      final user = User.fromJson(item as Map<String, dynamic>);
      if (user.username.toLowerCase() == username.toLowerCase()) {
        return user;
      }
    }

    throw const ApiException('User not found');
  }
}
