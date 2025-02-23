import 'dart:async';
import 'dart:convert';
import 'package:brooklynbs/main.dart';
import 'package:brooklynbs/src/model/user_model.dart';
import 'package:brooklynbs/src/pages/home.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retry/retry.dart';
import '../constants/end_points.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<void> autoLogin(WidgetRef ref) async {
    final token = await getToken();
    final loader = ref.read(loadingStateProvider);

    if (token != null) {
      loader.startLoader(navigatorKey.currentContext!);
      final user = await fetchUserFromToken(token);
      if (user != null) {
        ref.read(userStateProvider.notifier).login(user);
        print('✅ Auto-login successful');

        loader.stopLoader(navigatorKey.currentContext!);
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePageWithNav()),
        );
      } else {
        print('🔴 Token invalid, logging out...');
        await logout(ref);
      }
    } else {
      print('🔴 No saved token found');
    }
  }

  /// ✅ **Login and store token securely**
  Future<String?> login({
    required String emailOrId,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final bool isEmail = emailOrId.contains('@');
      final Map<String, dynamic> body = {
        isEmail ? 'email' : 'st_num': emailOrId,
        'password': password,
      };

      final response = await retry(
        () async => await http
            .post(
              Uri.parse(Endpoints.baseUrl),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 20)),
        retryIf: (e) => e is http.ClientException || e is TimeoutException,
        maxAttempts: 3,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('token')) {
          final String token = data['token'];
          await _saveToken(token);

          final userData = UserModel.fromJson(data);
          ref.read(userStateProvider.notifier).login(userData);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('_isFirstTime', false);

          return null;
        }
      }
      return 'Invalid email or password';
    } catch (e) {
      return 'Login error: $e';
    }
  }

  /// ✅ **Fetch user using stored token**
  Future<UserModel?> fetchUserFromToken(String token) async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(Endpoints.userData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print("🔴 Failed to fetch user data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching user from token: $e");
    }
    return null;
  }

  /// ✅ **Logout and clear stored data**
  Future<void> logout(WidgetRef ref) async {
    await _deleteToken();
    ref.read(userStateProvider.notifier).logout();

    print("✅ Logout successful!");
  }

  /// ✅ **Send password reset email**
  Future<void> sendPasswordResetEmail(String email) async {
    final token = await getToken();
    try {
      final response = await http.post(
        Uri.parse(Endpoints.forgetPw),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('✅ Password reset email sent successfully!');
      } else {
        final data = json.decode(response.body);
        print(
            '❌ Failed to send reset email: ${data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('❌ Error sending reset email: $e');
    }
  }

  /// ✅ **Secure Token Storage**
  Future<void> _saveToken(String token) async {
    await storage.write(key: 'st_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'st_token');
  }

  Future<void> _deleteToken() async {
    await storage.delete(key: 'st_token');
  }
}
