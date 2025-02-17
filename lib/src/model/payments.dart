class PaymentModel {
  final int id;
  final int stId;
  final String status;
  final String totalPayment;
  final String dueDate;
  final String? paidDate;
  final String amount;
  final String paidAmount;

  PaymentModel({
    required this.id,
    required this.stId,
    required this.status,
    required this.totalPayment,
    required this.dueDate,
    this.paidDate,
    required this.amount,
    required this.paidAmount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      stId: json['st_id'] as int,
      status: json['status'] as String,
      totalPayment: json['total_payment'] as String,
      dueDate: json['due_date'] as String,
      paidDate: json['paid_date'] as String?,
      amount: json['amount'] as String,
      paidAmount: json['paid_amount'] as String,
    );
  }
}

class PaymentResponse {
  final String message;
  final int totalAmount;
  final int totalPaidAmount;
  final int totalUnpaidAmount;
  final String totalPaid;
  final List<PaymentModel> data;

  PaymentResponse({
    required this.message,
    required this.totalAmount,
    required this.totalPaidAmount,
    required this.totalUnpaidAmount,
    required this.totalPaid,
    required this.data,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      message: json['message'] as String,
      totalAmount: json['total_amount'] as int,
      totalPaidAmount: json['total_paid_amount'] as int,
      totalUnpaidAmount: json['total_unpaid_amount'] as int,
      totalPaid: json['total_paid'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
