import 'package:clean_one/src/services/auth.dart';
import 'package:clean_one/src/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  // This function will handle the auto-login process by checking the saved token
  static Future<void> autoLogin(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Token exists, so user is already logged in, try to fetch user details
      final user = await AuthService().getSavedUser();
      if (user != null) {
        // User data exists, update state
        ref.read(userStateProvider.notifier).login(user);
      }
    }
  }
}
