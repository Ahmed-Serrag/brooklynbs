import 'package:clean_one/src/model/payment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

// StateNotifier to manage user state
class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  void login(UserModel user) {
    state = user; // Set the user when logged in
  }

  Future<void> logout() async {
    state = null; // Clear the user when logged out
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('name');
    await prefs.remove('stId');
    await prefs.remove('phone');
    await prefs.remove('ppURL');
    await prefs.remove('isLoggedIn'); // Clear the login flag
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
final userProvider = StateProvider<UserModel>((ref) {
  return UserModel(name: '', stID: '', email: '', phone: '', ppURL: '');
});

// Provider for storing payment history data
final paymentHistoryProvider = StateProvider<List<PaymentHistoryModel>>((ref) {
  return []; // Empty list as default for payment history
});

final selectedIndexProvider =
    StateProvider<int>((ref) => 0);  // Default index 0 (Home)