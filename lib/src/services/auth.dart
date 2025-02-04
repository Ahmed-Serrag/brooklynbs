import 'dart:convert';
import 'package:brooklynbs/src/model/course_model.dart';
import 'package:brooklynbs/src/model/payment_model.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../constants/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AuthService {
  // Login method
  Future<String?> login({
    required String emailOrId,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      final isEmail =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(emailOrId);

      // Prepare the request body based on the input type
      final body = json.encode({
        isEmail ? 'email' : 'stId':
            emailOrId, // Use 'email' if it's an email, otherwise use 'stID'
        'password': password,
      });

      final response = await http.post(
        Uri.parse(Endpoints.baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Endpoints.token}', // Make sure token is included
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // Extract user data and payment history and courses
          final userData = UserModel.fromJson(data['user']);
          ref.read(userStateProvider.notifier).login(userData);
          final paymentData = List<PaymentHistoryModel>.from(data['payments']
              .map((payment) => PaymentHistoryModel.fromJson(payment)));
          ref.read(paymentHistoryProvider.notifier).state = paymentData;

          final courseData = List<Course>.from(
            data['courses'].map((course) => Course.fromJson(course)),
          );
          ref.read(courseProvider.notifier).state = courseData;

          // Save user data and token to SharedPreferences
          await _saveTokenAndUserData(
              emailOrId, password, data['token'], userData);
          return null; // Login successful, no error message
        } else {
          return data['message'] ?? 'Login failed';
        }
      } else {
        return 'Invalid email or password';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  // Save JWT token and user data to SharedPreferences
  Future<void> _saveTokenAndUserData(String emailOrId, String password,
      String token, UserModel userData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('emailOrId', emailOrId);
    await prefs.setString('password', password);

    // Save the JWT token and user details
    await prefs.setString('token', token);
    await prefs.setString('email', userData.email);
    await prefs.setString('name', userData.name);
    await prefs.setString('stId', userData.stID);
    await prefs.setString('phone', userData.phone);
    await prefs.setString('ppURL', userData.ppURL);
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
    final token = prefs.getString('token'); // Retrieve the JWT token

    if (email != null && name != null && token != null) {
      return UserModel(
        name: name,
        email: email,
        stID: stID ?? '',
        phone: phone ?? '',
        ppURL: ppURL ?? '',
      );
    }

    return null; // Return null if user data is not available
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
