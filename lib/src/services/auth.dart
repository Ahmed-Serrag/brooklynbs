import 'dart:convert';
import 'package:clean_one/src/model/payment_model.dart';
import 'package:clean_one/src/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../services/end_points.dart';

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
          'Authorization': 'Bearer ${Endpoints.token}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // Extract user data and update provider
          final userData = UserModel.fromJson(data['user']);
          // print(userData);
          final paymentData = List<PaymentHistoryModel>.from(data['payments']
              .map((payment) => PaymentHistoryModel.fromJson(payment)));
          // Update login state
          ref.read(userStateProvider.notifier).login(userData);
          // Update user profile data
          ref.read(userProvider.notifier).state = userData;
          // Update payment history data
          ref.read(paymentHistoryProvider.notifier).state = paymentData;
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
}
