import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:brooklynbs/src/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentProvider2.notifier).fetchPayments(context, ref);
    });
  }

  String getOrdinal(int number) {
    if (number == 0) return 'First Payment';
    if (number == 1) return 'Second Payment';
    if (number == 2) return 'Third Payment';
    if (number == 3) return 'Fourth Payment';
    if (number == 4) return 'Fifth Payment';
    return '${number + 1}th Payment';
  }

  @override
  Widget build(BuildContext context) {
    final paymentHistoryAsync = ref.watch(paymentProvider2);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Payments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: paymentHistoryAsync.when(
          loading: () => const Center(child: Text('')),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (paymentHistory) {
            if (paymentHistory.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "No Payments Yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You have not made any payments yet.\nOnce you make a payment, it will appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: paymentHistory.length,
              itemBuilder: (context, index) {
                final payment = paymentHistory[index];

                return TransactionItem(
                  title: getOrdinal(index),
                  dueDate: payment.dueDate,
                  paidDate: payment.paidDate ?? '',
                  paidAmount: payment.paidAmount,
                  amount: payment.amount,
                  isCredit: payment.status == 'paid',
                  status: payment.status,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
