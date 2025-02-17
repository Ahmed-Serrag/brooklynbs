import 'package:brooklynbs/src/model/course_model.dart';
import 'package:brooklynbs/src/model/payment_model.dart';
import 'package:brooklynbs/src/model/payments.dart';
import 'package:brooklynbs/src/model/scholarShip.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:brooklynbs/src/services/user_data.dart';
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

  // Future<void> logout(BuildContext context, WidgetRef ref) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final loader = ref.read(loadingStateProvider);

  //   if (context.mounted) {
  //     loader.startLoader(context); // ✅ Show Loader Overlay
  //   }

  //   try {
  //     print("🔵 Logout started...");
  //     await prefs.remove('token');
  //     await prefs.remove('email');
  //     await prefs.remove('name');
  //     await prefs.remove('stId');
  //     await prefs.remove('phone');
  //     await prefs.remove('ppURL');
  //     await prefs.remove('isLoggedIn');
  //     await prefs.remove('password');
  //     await prefs.remove('emailOrId');

  //     // ✅ Reset Riverpod state
  //     ref.read(userStateProvider.notifier).state = null;
  //     ref.read(paymentHistoryProvider.notifier).state = [];
  //     ref.read(courseProvider.notifier).state = [];
  //     ref.read(selectedIndexProvider.notifier).state = 0;

  //     if (context.mounted) {
  //       print("🟢 Stopping Loader...");
  //       loader.stopLoader(context);

  //       // ✅ Delay Navigation Until the Loader is Hidden
  //       await Future.delayed(const Duration(milliseconds: 200), () {
  //         if (context.mounted) {
  //           print("🟡 Navigating to LoginPage...");
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => const LoginPage()),
  //             (route) => false, // Removes all previous routes
  //           );
  //         } else {
  //           print("❌ Context unmounted! Cannot navigate.");
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print("🔴 Logout Error: $e");
  //   }
  // }

  bool isLoggedIn() {
    return state != null; // Return true if user is not null
  }
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

final paymentHistoryProvider = StateProvider<List<PaymentHistoryModel>>((ref) {
  return []; // Empty list as default for payment history
});
final courseProvider = StateProvider<List<Course>>((ref) {
  return []; // Default empty list for courses
});

final selectedIndexProvider =
    StateProvider<int>((ref) => 0); // Default index 0 (Home)

final dataServiceProvider = Provider((ref) => DataService());

final courseProvider2 =
    StateNotifierProvider<CourseNotifier2, AsyncValue<List<Course>>>((ref) {
  return CourseNotifier2(ref);
});

class CourseNotifier2 extends StateNotifier<AsyncValue<List<Course>>> {
  final Ref ref;

  CourseNotifier2(this.ref) : super(const AsyncValue.loading());

  Future<void> fetchCourses(BuildContext context) async {
    final loadingState = ref.read(loadingStateProvider);
    final dataService = ref.read(dataServiceProvider);

    try {
      // Start the loader
      loadingState.startLoader(context);
      state = const AsyncValue.loading(); // Set loading state

      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('st_token');

      if (token == null) {
        throw Exception('No token found');
      }

      // Fetch and update courses using the DataService
      final courses = await dataService.fetchCourses(token);
      if (courses != null) {
        state = AsyncValue.data(courses); // Set data state
      } else {
        throw Exception('Failed to fetch courses');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current); // Set error state
    } finally {
      // Stop the loader
      loadingState.stopLoader(context);
    }
  }

  void setCourses(List<Course> courses) {
    state = AsyncValue.data(courses); // Set data state
  }
}

final paymentProvider2 =
    StateNotifierProvider<PaymentNotifier2, AsyncValue<List<PaymentModel>>>(
        (ref) {
  return PaymentNotifier2(ref);
});

class PaymentNotifier2 extends StateNotifier<AsyncValue<List<PaymentModel>>> {
  final Ref ref;

  PaymentNotifier2(this.ref) : super(const AsyncValue.loading());

  Future<void> fetchPayments(BuildContext context, WidgetRef ref) async {
    final loadingState = ref.read(loadingStateProvider);
    final dataService = ref.read(dataServiceProvider);

    try {
      print("🔵 Fetching payments...");
      loadingState.startLoader(context);
      state = const AsyncValue.loading();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('st_token');

      if (token == null) {
        print("❌ No token found!");
        throw Exception('No token found');
      }

      final paymentResponse = await dataService.fetchPayments(token);

      if (paymentResponse != null) {
        print("🟢 Payments fetched: ${paymentResponse.data.length} items");
        state = AsyncValue.data(paymentResponse.data);
      } else {
        print("❌ Failed to fetch payments");
        throw Exception('Failed to fetch payments');
      }
    } catch (e) {
      print("🔴 Error fetching payments: $e");
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      loadingState.stopLoader(context);
    }
  }
}
