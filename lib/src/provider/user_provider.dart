import 'package:brooklynbs/src/model/course_model.dart';
import 'package:brooklynbs/src/model/payment_model.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

// StateNotifier to manage user state
class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  void login(UserModel user) {
    state = user; // Set the user when logged in
  }

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final loader = ref.read(loadingStateProvider);

    if (context.mounted) {
      loader.startLoader(context); // ✅ Show Loader Overlay
    }

    try {
      print("🔵 Logout started...");
      await prefs.remove('token');
      await prefs.remove('email');
      await prefs.remove('name');
      await prefs.remove('stId');
      await prefs.remove('phone');
      await prefs.remove('ppURL');
      await prefs.remove('isLoggedIn');
      await prefs.remove('password');
      await prefs.remove('emailOrId');

      // ✅ Reset Riverpod state
      ref.read(userStateProvider.notifier).state = null;
      ref.read(paymentHistoryProvider.notifier).state = [];
      ref.read(courseProvider.notifier).state = [];
      ref.read(selectedIndexProvider.notifier).state = 0;

      if (context.mounted) {
        print("🟢 Stopping Loader...");
        loader.stopLoader(context); 

        // ✅ Delay Navigation Until the Loader is Hidden
        await Future.delayed(const Duration(milliseconds: 200), () {
          if (context.mounted) {
            print("🟡 Navigating to LoginPage...");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false, // Removes all previous routes
            );
          } else {
            print("❌ Context unmounted! Cannot navigate.");
          }
        });
      }
    } catch (e) {
      print("🔴 Logout Error: $e");
    }
  }

  bool isLoggedIn() {
    return state != null; // Return true if user is not null
  }
}

// Provider for the UserStateNotifier
final userStateProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

// Define a provider for user data
// final userProvider = StateProvider<UserModel>((ref) {
//   return UserModel(name: '', stID: '', email: '', phone: '', ppURL: '');
// });

// Provider for storing payment history data
final paymentHistoryProvider = StateProvider<List<PaymentHistoryModel>>((ref) {
  return []; // Empty list as default for payment history
});

final courseProvider = StateProvider<List<Course>>((ref) {
  return []; // Default empty list for courses
});

final selectedIndexProvider =
    StateProvider<int>((ref) => 0); // Default index 0 (Home)
