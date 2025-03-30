// payment_model.dart

enum PaymentStatus {
  pending,
  completed,
  failed;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }

  factory PaymentStatus.fromString(String status) {
    return values.firstWhere(
      (e) => e.toString().split('.').last == status.toLowerCase(),
      orElse: () => PaymentStatus.pending,
    );
  }
}

class PaymentModel {
  final int id;
  final int studentId;
  final double amount;
  final String paymentMethod;
  final PaymentStatus status; // Changed to PaymentStatus enum
  final String date;
  final String? nextDueDate;
  final String? paymentSlip;
  final String createdAt;
  final String updatedAt;
  final int libraryId;
  final String verify;

  PaymentModel({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.date,
    required this.nextDueDate,
    required this.paymentSlip,
    required this.createdAt,
    required this.updatedAt,
    required this.libraryId,
    required this.verify,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      amount: double.tryParse(json['amount'].toString()) ??
          0.0, // Parse string to double
      paymentMethod: json['payment_method'] ?? '',
      status: PaymentStatus.fromString(
          json['status'] ?? 'pending'), // Convert string to enum
      date: json['payment_date'] ?? '',
      nextDueDate: json['next_due_date'],
      paymentSlip: json['payment_slip'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      libraryId: json['library_id'] ?? 0,
      verify: json['verify'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PaymentModel{id: $id, studentId: $studentId, amount: $amount, paymentMethod: $paymentMethod, status: $status, date: $date, nextDueDate: $nextDueDate, paymentSlip: $paymentSlip, createdAt: $createdAt, updatedAt: $updatedAt, libraryId: $libraryId, verify: $verify}';
  }
}
