import 'package:brooklynbs/src/constants/end_points.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewPage({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success=true')) {
              _handleSuccessfulPayment(Uri.parse(request.url));
              return NavigationDecision.prevent; // Prevent redirection
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Page loaded: $url');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl)); // Load Paymob URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }

  bool _paymentProcessed = false; // Add this at class level

  Future<void> _handleSuccessfulPayment(Uri uri) async {
    if (_paymentProcessed) return; // Prevent duplicate calls
    _paymentProcessed = true;

    // Extract relevant parameters
    String? transactionId = uri.queryParameters['id'];
    String? amountString = uri.queryParameters['amount_cents'];
    String? paymentMethod = uri.queryParameters['source_data.sub_type'];
    String? status =
        uri.queryParameters['success'] == "true" ? "Approved" : "Failed";

    // Convert amount from cents to EGP
    double amountDouble = (int.parse(amountString ?? "0")) / 100;
    int amount = amountDouble.toInt();

    final requestData = {
      "data": {
        "student_num": transactionId ?? "123456",
        "name": paymentMethod ?? "MasterCard",
        "message": "Payment for transaction $transactionId",
        "type": "Payment",
        "Email": "test@example.com",
        "phone": "0123456789",
        "GroupID": "FROM PAYMENT",
      }
    };

    print("Extracted Payment Data: ${jsonEncode(requestData)}");

    // Send the extracted data asynchronously without waiting
    _submitPaymentData(requestData);

    // Delay then navigate back
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context, {"status": status, "amount": amount});
      }
    });
  }

// Function to submit payment data
  Future<void> _submitPaymentData(Map<String, dynamic> requestData) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.request), // API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Endpoints.reqToken}',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print(
            "Data submitted successfully!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! to database");
      } else {
        print('Submission failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error submitting payment data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
