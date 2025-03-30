// models/student_model.dart
class StudentModel {
  final int id;
  final String name;
  final String dob;
  final String gender;
  final String studyFor;
  final String joiningFrom;
  final String membershipPlan;
  final String expiringDate;
  final SeatModel? seat;
  final List<PaymentModel> payments;
  final String? profilePhoto;
  final int libraryId;

  StudentModel({
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
    required this.studyFor,
    required this.joiningFrom,
    required this.membershipPlan,
    required this.expiringDate,
    this.seat,
    required this.payments,
    this.profilePhoto,
    required this.libraryId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      dob: json['dob'],
      gender: json['gender'],
      studyFor: json['study_for'],
      joiningFrom: json['joining_from'],
      membershipPlan: json['membership_plan'] ?? 'N/A',
      expiringDate: json['expiring_date'] ?? '',
      seat: json['seat'] != null ? SeatModel.fromJson(json['seat']) : null,
      payments: (json['payments'] as List)
          .map((payment) => PaymentModel.fromJson(payment))
          .toList(),
      profilePhoto: json['profile_photo'],
      libraryId: json['library_id'],
    );
  }
}

// ✅ Seat Model
class SeatModel {
  final int id;
  final String number;

  SeatModel({required this.id, required this.number});

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'],
      number: json['number'],
    );
  }
}

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
