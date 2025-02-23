import 'package:brooklynbs/src/model/course_model.dart';
import 'package:brooklynbs/src/model/payment_model.dart';
import 'package:brooklynbs/src/model/payments.dart';
import 'package:brooklynbs/src/model/scholarShip.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:brooklynbs/src/services/auth.dart';
import 'package:brooklynbs/src/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(ref),
);

class UserStateNotifier extends StateNotifier<UserModel?> {
  final Ref ref;
  final storage = const FlutterSecureStorage();

  UserStateNotifier(this.ref) : super(null) {
    _loadUserOnRestart();
  }

  void login(UserModel user) {
    state = user;
  }

  void logout() async {
    state = null;
    await storage.delete(key: 'st_token');
  }

  Future<void> _loadUserOnRestart() async {
    final token = await AuthService().getToken();
    if (token != null) {
      final user = await AuthService().fetchUserFromToken(token);
      if (user != null) {
        state = user;
      }
    }
  }
}

final selectedIndexProvider =
    StateProvider<int>((ref) => 0); // Default index 0 (Home)
final deepLinkStateProvider = StateProvider<Uri?>((ref) => null);

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
      loadingState.startLoader(context);
      state = const AsyncValue.loading();

      final token = await AuthService().getToken();

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

      final token = await AuthService().getToken();

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
