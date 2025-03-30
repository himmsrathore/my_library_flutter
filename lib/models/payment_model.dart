// ✅ Payment Model
class PaymentModel {
  final int id;
  final double amount;
  final String date;
  final String status;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(), // Ensure it's a double
      date: json['date'],
      status: json['status'],
    );
  }
}
