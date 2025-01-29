import 'dart:convert';
import 'package:clean_one/src/constants/end_points.dart';
import 'package:http/http.dart' as http;

class PaymobManager {
  Future<String> getPaymentKey(int amount, String currency, String first_name,
      String last_name, String email, String phone) async {
    try {
      String auth_token = await _getAuthToken();
      int orderId = await _getOrderId(
        token: auth_token,
        price: (100 * amount).toString(),
        firstName: first_name,
        lastName: last_name,
        email: email,
        phone: phone,
      );
      String paymentKey = await _getPaymentKey((100 * amount).toString(),
          first_name, last_name, email, phone, orderId.toString());
      return paymentKey;
    } catch (e) {
      // Handle the error here
      print("EXCEPTIONNNNNNNNNNNNNNNNNNNNNNNNN: $e");
      throw Exception("Failed to get payment key: $e");
    }
  }

  Future<String> _getAuthToken() async {
    final response = await http.post(
      Uri.parse(PayMob.reqToken),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"api_key": PayMob.api_key}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Accept 201 as success
      final responseBody = jsonDecode(response.body);

      // Check if 'token' exists in the response
      if (responseBody.containsKey('token') && responseBody['token'] != null) {
        PayMob.token = responseBody['token'];
        print("THIS IS THE TOKEN: $PayMob.token");
        return responseBody['token'];
      } else {
        throw Exception("Auth token is null or missing in response.");
      }
    } else {
      throw Exception(
          "Failed to fetch auth token. Status: ${response.statusCode}, Body: ${response.body}");
    }
  }

  Future<String> _getPaymentKey(String priceOrder, String firstName,
      String lastName, String email, String phone, String orderId) async {
    final response = await http.post(
      Uri.parse(PayMob.paymentorder),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "auth_token": PayMob.token,
        "amount_cents": priceOrder,
        "expiration": 3600,
        "order_id": orderId,
        "billing_data": {
          "apartment": "NA",
          "email": email,
          "floor": "NA",
          "first_name": firstName,
          "street": "NA",
          "building": "NA",
          "phone_number": phone,
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": lastName,
          "state": "NA"
        },
        "currency": "EGP",
        "integration_id": PayMob.integrationIdCard,
        "lock_order_when_paid": false
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Accept 201 as success
      final responseBody = jsonDecode(response.body);
      PayMob.afterPayToken = responseBody['token'];
      // Check if 'token' exists in the response
      if (responseBody.containsKey('token') && responseBody['token'] != null) {
        PayMob.paymentkey = responseBody['token'];
        print("THIS IS THE PAYMENT KEY: $PayMob.paymentkey");
        return responseBody['token'];
      } else {
        throw Exception("Payment key is null or missing in response.");
      }
    } else {
      throw Exception(
          "Failed to fetch payment key. Status: ${response.statusCode}, Body: ${response.body}");
    }
  }

  Future<int> _getOrderId({
    required String token,
    required String price,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse(PayMob.orderId),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'auth_token': token,
        "delivery_needed": false,
        "amount_cents": price,
        "currency": "EGP",
        "items": [],
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Accept 201 as success
      final responseBody = jsonDecode(response.body);

      // Check if 'id' exists in the response
      if (responseBody.containsKey('id') && responseBody['id'] != null) {
        PayMob.userOrderId = responseBody['id'].toString();
        print("This is orderID: $PayMob.userOrderId");
        return responseBody['id'];
      } else {
        throw Exception("Order ID is null or missing in response.");
      }
    } else {
      throw Exception(
          "Failed to fetch order ID. Status: ${response.statusCode}, Body: ${response.body}");
    }
  }
}
