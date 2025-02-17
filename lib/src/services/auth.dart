import 'dart:async';
import 'dart:convert';
import 'package:brooklynbs/src/model/payment_model.dart';
import 'package:brooklynbs/src/model/user_model.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:retry/retry.dart';
import '../constants/end_points.dart';

class AuthService {
  // Auto-login method
  Future<void> autoLogin(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    // final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // final token = prefs.getString('st_token');
    final emailOrId = prefs.getString('emailOrId');
    final password = prefs.getString('password');

    if (emailOrId != null && password != null) {
      try {
        final bool isEmail = emailOrId.contains('@');

        final Map<String, dynamic> body = {
          isEmail ? 'email' : 'st_num': emailOrId,
          'password': password,
        };
        // Use the credentials to log in again
        final response = await retry(
          () async {
            return await http
                .post(
              Uri.parse(Endpoints.baseUrl),
              headers: {
                'Content-Type': 'application/json',
              },
              body: json.encode(body),
            )
                .timeout(const Duration(seconds: 10), onTimeout: () {
              throw TimeoutException(
                  'The connection has timed out, please try again.');
            });
          },
          retryIf: (e) => e is http.ClientException || e is TimeoutException,
          maxAttempts: 3,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final prefs = await SharedPreferences.getInstance();

          if (data.containsKey('token') && data['token'] != null) {
            final String token = data['token'];
            await prefs.setString('st_token', token);
            await prefs.setBool('isLoggedIn', true);
            final userData = UserModel.fromJson(data);
            await _saveTokenAndUserData(emailOrId, password, token);
            ref.read(userStateProvider.notifier).login(userData);

            print('Auto-login successful');
            return null;
          } else {
            print('Auto-login failed: ${data['message']}');
          }
        } else {
          print('Invalid credentials');
        }
      } catch (e) {
        print('Error during auto-login: $e');
      }
    } else {
      print('No saved credentials found');
    }
  }

  // Login method
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
        () async {
          return await http
              .post(
            Uri.parse(Endpoints.baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(body),
          )
              .timeout(const Duration(seconds: 10), onTimeout: () {
            throw TimeoutException(
                'The connection has timed out, please try again.');
          });
        },
        retryIf: (e) => e is http.ClientException || e is TimeoutException,
        maxAttempts: 3,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        if (data.containsKey('token') && data['token'] != null) {
          final String token = data['token'];

          // ✅ Store token for future requests
          await prefs.setString('st_token', token);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setBool('_isFirstTime', false);

          print("✅ Login Successful! Token saved.");

          // ✅ Fetch full user data and store it
          final userData = UserModel.fromJson(data);
          await _saveTokenAndUserData(emailOrId, password, token);
          ref.read(userStateProvider.notifier).login(userData);

          return null; // Login successful
        } else {
          print("🔴 Login failed: ${data['message']}");
          return data['message'] ?? 'Login failed: No message provided';
        }
      } else {
        print("🔴 Server error with status code ${response.statusCode}");
        return 'Invalid email or password';
      }
    } catch (e) {
      print("❌ Exception occurred: $e");
      if (e is TimeoutException) {
        return 'Request timed out. Please try again.';
      } else if (e is http.ClientException) {
        return 'Network error. Check your internet connection.';
      } else {
        return 'An unexpected error occurred: $e';
      }
    }
  }

  // Save JWT token and user data to SharedPreferences
  Future<void> _saveTokenAndUserData(
      String emailOrId, String password, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailOrId', emailOrId);
    await prefs.setString('password', password);
    // Save the JWT token and user details
    await prefs.setString('st_token', token);
    await prefs.setBool('isLoggedIn', true); // Flag for login status
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      return null; // No logged-in user
    }

    // Save credentials and token securely

    final email = prefs.getString('email');
    final name = prefs.getString('name');
    final stID = prefs.getString('stId');
    final phone = prefs.getString('phone');
    final ppURL = prefs.getString('ppURL');
    final token = prefs.getString('token');
    final phones = prefs.getStringList('phones');

    if (email != null && name != null && token != null) {
      return UserModel(
        name: name,
        email: email,
        stID: stID ?? '',
        phone: phone ?? '',
        phones: phones ?? [],
        ppURL: ppURL ?? '',
      );
    }

    return null; // Return null if user data is not available
  }

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final loader = ref.read(loadingStateProvider);

    // Start the loader if the context is still mounted
    if (context.mounted) {
      loader.startLoader(context); // Show Loader Overlay
    }

    try {
      print("🔵 Logout started...");
      await prefs.remove('token');
      await prefs.remove('isLoggedIn');
      await prefs.remove('password');
      await prefs.remove('emailOrId');

      // Reset Riverpod state
      ref.read(paymentHistoryProvider.notifier).state = [];
      ref.read(courseProvider.notifier).state = [];

      // Stop the loader if the context is still mounted

      loader.stopLoader(context);
      print("🟡 Loader stopped.");

      // Navigate to LoginPage immediately
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false, // Removes all previous routes
      );

      print("🟡 Navigating to LoginPage...");
    } catch (e) {
      print("🔴 Logout Error: $e");
    }
  }

  Future<String?> sendPasswordToUserEmail(String userId) async {
    String? newPassword;
    String? userEmail;

    try {
      // First API call to get new password
      final response = await http.post(
        Uri.parse(Endpoints.forgetPw),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Endpoints.token}',
        },
        body: json.encode({
          'stId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['user'] != null) {
          newPassword = data['user']['password'];
          userEmail = data['user']['email'];

          // Define Gmail credentials
          String username = 'system.bbs.2024@gmail.com';
          String password = "fkdb ouzl samn sfyy";

          // Create SMTP server configuration
          final smtpServer = gmail(username, password);

          // Create email message
          final message = Message()
            ..from = Address(username)
            ..recipients.add(userEmail!)
            ..subject = 'Password Reset Request'
            ..text =
                'Your new password is: $newPassword\n\nPlease change it after logging in.';

          try {
            // Send the email
            final sendReport = await send(message, smtpServer);
            print('Message sent: $sendReport');
            return null; // Success
          } catch (e) {
            return 'Error sending email: $e';
          }
        } else {
          return data['message'] ?? 'Failed to send reset email';
        }
      } else {
        return 'Failed to send request to reset password';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}
