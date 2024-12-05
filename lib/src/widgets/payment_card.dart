import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String dueDate;
  final String paidDate;
  final String amount;
  final bool isCredit; // True for income, false for expense
  final String status; // New field for payment status
  final String paidAmount;

  const TransactionItem({
    super.key,
    required this.title,
    required this.dueDate,
    required this.amount,
    required this.isCredit,
    required this.status, // Receive status here
    required this.paidDate, // Receive paid date here
    required this.paidAmount, // Receive paid amount here
  });

  @override
  Widget build(BuildContext context) {
    // Define color based on the payment status
    Color statusColor;
    Widget statusIcon;
    String subtitle = ' ';
    String remainingValue = ' ';
    String money = '';
    double remainingAmount = double.parse(amount) - double.parse(paidAmount);
    subtitle = 'Remaining: $remainingAmount ';
    final currentTheme = Theme.of(context);

    if (status == 'paid') {
      statusColor = Colors.green;
      statusIcon = const Icon(Icons.check_circle, color: Colors.green);
      subtitle = 'Paid Date: $paidDate ';
      remainingValue = 'Paid Amount: $paidAmount ';
      money = (isCredit ? '+' : '-') + amount;
    } else if (status == 'unpaid') {
      statusColor = Colors.red;
      statusIcon = const Icon(Icons.cancel, color: Colors.red);
      subtitle = 'Due Date: $dueDate ';
      remainingValue = ' ';
      money = amount;
    } else if (status == 'Portion Paid') {
      statusColor = Colors.orange;
      statusIcon = const Icon(Icons.payment, color: Colors.orange);
      subtitle = 'Due Date: $dueDate ';
      remainingValue = 'Remaining Amount: $remainingAmount ';
      // money = '   $amount\n ($paidAmount)';
      money = '$paidAmount/$amount';
    } else {
      statusColor = Colors.grey;
      statusIcon = const Icon(Icons.error,
          color: Colors.grey); // Default case for unknown status
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.1),
          //   blurRadius: 10,
          //   offset: const Offset(0, 6),
          // ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.primaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: currentTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  remainingValue,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: currentTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Transaction Amount
          Text(
            money,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 16),
          // Payment Status Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: statusIcon,
          ),
        ],
      ),
    );
  }
}
