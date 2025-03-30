// models/student_model.dart
import 'seat_model.dart';
import 'payment_model.dart';

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
