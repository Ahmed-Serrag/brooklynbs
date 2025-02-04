import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:brooklynbs/src/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  String getOrdinal(int number) {
    if (number == 0) return 'First Payment';
    if (number == 1) return 'Second Payment';
    if (number == 2) return 'Third Payment';
    if (number == 3) return 'Fourth Payment';
    if (number == 4) return 'Fifth Payment';
    return '${number + 1}th Payment';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentHistory = ref.watch(paymentHistoryProvider);
    final backgroundColor = Theme.of(context).cardColor;
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: const Text(
          'Payments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), // Rounded top-left corner
            topRight: Radius.circular(30), // Rounded top-right corner
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: paymentHistory.length,
          itemBuilder: (context, index) {
            final payment = paymentHistory[index];

            return TransactionItem(
              title: getOrdinal(index), // Use the ordinal title here
              dueDate: payment.dueDate, // Pass the string directly
              paidDate: payment.paidDate, // Pass the
              paidAmount: payment.paidAmount,

              amount: payment.amount, // Pass the string directly
              isCredit:
                  payment.status == 'paid', // Assuming 'paid' means a credit
              status: payment.status,
            );
          },
        ),
      ),
    );
  }
}
