class PaymentHistoryModel {
  final String stID;
  final String status;
  final String totalPayment;
  final String dueDate;
  final String paidDate;
  final String amount;
  final String paidAmount;

  PaymentHistoryModel({
    required this.stID,
    required this.status,
    required this.totalPayment,
    required this.dueDate,
    required this.paidDate,
    required this.amount,
    required this.paidAmount,
  });

  // Factory method to create a PaymentHistoryModel from JSON
  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      stID: json['stID'] ?? '',
      status: json['Status'] ?? '',
      totalPayment: json['TotalPayment'] ?? '',
      dueDate: json['due_date'] ?? '',
      paidDate: json['paid_date'] ?? '',
      amount: json['amount'] ?? '',
      paidAmount: json['PaidAmount'] ?? '',
    );
  }
}
