import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokens {
  final String access;
  final String refresh;
  AuthTokens({required this.access, required this.refresh});
  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    access: json['access'] as String,
    refresh: json['refresh'] as String,
  );
}

class AuthService {
  final String baseUrl;
  final http.Client client;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthService({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  Future<AuthTokens> login(String username, String password) async {
    final res = await client.post(
      Uri.parse('$baseUrl/api/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final tokens = AuthTokens.fromJson(data);
      await _saveTokens(tokens);
      return tokens;
    } else {
      final err = res.body.isNotEmpty ? res.body : res.reasonPhrase;
      throw Exception('Login failed: ${res.statusCode} $err');
    }
  }

  Future<void> _saveTokens(AuthTokens tokens) async {
    await storage.write(key: 'access_token', value: tokens.access);
    await storage.write(key: 'refresh_token', value: tokens.refresh);
  }

  Future<String?> getAccessToken() => storage.read(key: 'access_token');
  Future<void> logout() async {
    await storage.deleteAll();
    // Optionally call /api/auth/logout/ to blacklist refresh token.
  }
}
