import 'dart:convert';
import 'package:clean_one/src/model/payment_model.dart';
import 'package:clean_one/src/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../services/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          // Extract user data and payment history
          final userData = UserModel.fromJson(data['user']);
          // Update provider states
          ref.read(userStateProvider.notifier).login(userData);
          ref.read(userProvider.notifier).state = userData;
          final paymentData = List<PaymentHistoryModel>.from(data['payments']
              .map((payment) => PaymentHistoryModel.fromJson(payment)));
          ref.read(paymentHistoryProvider.notifier).state = paymentData;

          // Save user data and token to SharedPreferences
          await _saveTokenAndUserData(data['token'], userData);

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
  Future<void> _saveTokenAndUserData(String token, UserModel userData) async {
    final prefs = await SharedPreferences.getInstance();

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

// Retrieve saved user data from SharedPreferences

// Logout method to clear SharedPreferences
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('email');
  await prefs.remove('name');
  await prefs.remove('stId');
  await prefs.remove('phone');
  await prefs.remove('ppURL');
  await prefs.remove('isLoggedIn'); // Clear the login flag
}






  // Send password reset email method
  // Future<String?> sendPasswordResetEmail(String userId) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           '${Endpoints.baseUrl}/forget-password'), // Make sure this is the correct endpoint
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${Endpoints.token}',
  //       },
  //       body: json.encode({
  //         'userId': userId,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       if (data['success'] == true) {
  //         final newPassword = data[
  //             'newPassword']; // Assuming the backend sends the new password

  //         // Now, send the password to the user via email
  //         await _sendPasswordToUserEmail(newPassword);

  //         return null; // Password reset email sent successfully
  //       } else {
  //         return data['message'] ?? 'Failed to send reset email';
  //       }
  //     } else {
  //       return 'Failed to send request to reset password';
  //     }
  //   } catch (e) {
  //     return 'An error occurred: $e';
  //   }
  // }

  // Private method to send email with password
  // Future<void> _sendPasswordToUserEmail(String newPassword) async {
  //   final email = Email(
  //     body:
  //         'Your new password is: $newPassword\n\nPlease change it after logging in.',
  //     subject: 'Password Reset Request',
  //     recipients: [
  //       'user@example.com'
  //     ], // This should be dynamically set with the user's email
  //     isHTML: false,
  //   );

  //   try {
  //     await FlutterEmailSender.send(email); // This is where the email is sent
  //   } catch (e) {
  //     print('Error sending email: $e');
  //   }
  // }

