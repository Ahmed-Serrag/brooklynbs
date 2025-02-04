import 'package:brooklynbs/src/model/user_model.dart';

import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:brooklynbs/src/model/course_model.dart';
import 'package:brooklynbs/src/model/payment_model.dart';
import 'package:http/http.dart' as http;
import '../constants/end_points.dart';

class AuthManager {
  static Future<void> autoLogin(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch saved credentials
    final emailOrId = prefs.getString('emailOrId');
    final password = prefs.getString('password');

    if (emailOrId != null && password != null) {
      try {
        final isEmail =
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(emailOrId);

        // Use the credentials to log in again
        final response = await http.post(
          Uri.parse(Endpoints.baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${Endpoints.token}', // Make sure token is included
          },
          body: json.encode({
            isEmail ? 'email' : 'stId':
                emailOrId, // Use 'email' if it's an email, otherwise use 'stID'
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['success'] == true) {
            // Update user provider
            final userData = UserModel.fromJson(data['user']);
            ref.read(userStateProvider.notifier).login(userData);

            // Update payment and course providers
            final paymentData = List<PaymentHistoryModel>.from(data['payments']
                .map((payment) => PaymentHistoryModel.fromJson(payment)));
            ref.read(paymentHistoryProvider.notifier).state = paymentData;

            final courseData = List<Course>.from(
              data['courses'].map((course) => Course.fromJson(course)),
            );
            ref.read(courseProvider.notifier).state = courseData;

            print('Auto-login successful');
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
}
