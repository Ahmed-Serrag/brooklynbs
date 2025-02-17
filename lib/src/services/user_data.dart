import 'dart:convert';
import 'package:brooklynbs/src/model/payments.dart';
import 'package:brooklynbs/src/model/scholarShip.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:brooklynbs/src/constants/end_points.dart';

class DataService {
  Future<List<Course>?> fetchCourses(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.userData), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['data'] != null && data['data']['scholarship'] != null) {
          // Parse the scholarship data, including courses
          final scholarship = Scholarship.fromJson(data['data']['scholarship']);
          return scholarship.courses; // Return the list of courses
        } else {
          print('No scholarship data found');
          return null;
        }
      } else {
        print('Failed to fetch student data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching student data: $e');
      return null;
    }
  }

  Future<void> fetchAndUpdateCourses(String token, WidgetRef ref) async {
    final courses = await fetchCourses(token);

    if (courses != null) {
      // Update the course provider with the fetched courses
      ref.read(courseProvider2.notifier).setCourses(courses);
      print('Courses updated successfully');
    } else {
      print('Failed to fetch or update courses');
    }
  }

  Future<PaymentResponse?> fetchPayments(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.payments), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PaymentResponse.fromJson(data); // Parse the response
      } else {
        print('Failed to fetch payments: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching payments: $e');
      return null;
    }
  }
}
