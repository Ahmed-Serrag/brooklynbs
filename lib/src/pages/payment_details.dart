import 'package:brooklynbs/src/model/user_model.dart';
import 'package:brooklynbs/src/pages/payment_page.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:brooklynbs/src/services/paymob_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String amount;
  final String paidAmount;
  final double remainingAmount;
  final String status;
  final String dueDate;

  const PaymentDetailPage({
    super.key,
    required this.title,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.dueDate,
  });

  @override
  ConsumerState<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends ConsumerState<PaymentDetailPage> {
  bool isPartialPayment = false;
  TextEditingController partialAmountController = TextEditingController();
  double selectedAmount = 0.0;
  double updatedRemainingAmount = 0.0;

  @override
  void initState() {
    super.initState();
    selectedAmount = widget.remainingAmount;
    updatedRemainingAmount = widget.remainingAmount;
  }

  void _updateSelectedAmount() {
    setState(() {
      double? enteredAmount = double.tryParse(partialAmountController.text);
      if (isPartialPayment &&
          enteredAmount != null &&
          enteredAmount > 0 &&
          enteredAmount <= widget.remainingAmount) {
        selectedAmount = enteredAmount;
        updatedRemainingAmount = widget.remainingAmount - enteredAmount;
      } else {
        selectedAmount = widget.remainingAmount;
        updatedRemainingAmount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 60, color: Colors.blue),
                const SizedBox(height: 10),
                Text("Payment Total",
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
                Text("£ ${widget.amount}",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const Divider(thickness: 1, height: 20),
                _buildPaymentDetailRow("Due Date", widget.dueDate),
                _buildPaymentDetailRow("Account", user?.name ?? "Unknown"),
                const Divider(thickness: 1, height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("Partial Payment",
                //         style: TextStyle(fontSize: 14, color: Colors.black)),
                //     Switch(
                //       value: isPartialPayment,
                //       onChanged: (value) {
                //         setState(() {
                //           isPartialPayment = value;
                //           _updateSelectedAmount();
                //         });
                //       },
                //       activeColor: Colors.white,
                //       activeTrackColor: Colors.blue,
                //       inactiveTrackColor: Colors.grey[400],
                //       inactiveThumbColor: Colors.white,
                //     ),
                //     Text("Full Payment",
                //         style: TextStyle(fontSize: 14, color: Colors.black)),
                //   ],
                // ),
                if (isPartialPayment)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: partialAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        _updateSelectedAmount();
                      },
                    ),
                  ),
                _buildPaymentDetailRow("Total Payment", "£${widget.amount}"),
                _buildPaymentDetailRow("To be Paid", "£${selectedAmount}"),
                _buildPaymentDetailRow(
                    "Remaining Amount", "£${updatedRemainingAmount}"),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (user != null) {
                      await _pay(user, selectedAmount, context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                  ),
                  child: Text("Pay £${selectedAmount.toInt()}"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPaymentDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
        Text(value,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

var paymentData = {
  "data": {
    "student_num": '',
    "name": '',
    "message": '',
    "type": '',
    "Email": '',
    "phone": '',
    "GroupID": '',
  },
};
Future<Map<String, dynamic>?> _pay(
    final UserModel user, double amount, BuildContext context) async {
  try {
    String paymentKey = await PaymobManager().getPaymentKey(
      amount.toInt(),
      "EGP",
      user.name.split(' ').first,
      user.name.split(' ').last,
      user.email,
      user.phone,
    );

    // Navigate to WebView
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebViewPage(
          paymentUrl:
              "https://accept.paymob.com/api/acceptance/iframes/726764?payment_token=$paymentKey",
        ),
      ),
    );

    if (result != null && result["status"] == "Approved") {
      _showSuccessDialog(context, result["amount"]); // ✅ Show success
    } else if (result == null || result["status"] == "Failed") {
      _showFailureDialog(context); // ✅ Show failure only once
    }

    return result;
  } catch (error) {
    print("Payment error: $error");
    _showFailureDialog(context); // ✅ Show failure for actual errors
    return null;
  }
}

void _showFailureDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 60)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Payment Failed",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Something went wrong. Please try again.",
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void _showSuccessDialog(BuildContext context, int amount) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
            child: Icon(Icons.check_circle, color: Colors.green, size: 60)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Payment Successful!",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("You have successfully paid £$amount.",
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}
