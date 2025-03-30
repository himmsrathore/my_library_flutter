class AttendanceModel {
  final int id;
  final int studentId;
  final String dateAttended;
  final String checkIn;
  final String? checkOut;
  final int seatId;
  final int libraryId;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.dateAttended,
    required this.checkIn,
    this.checkOut,
    required this.seatId,
    required this.libraryId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      studentId: json['student_id'],
      dateAttended: json['date_attended'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      seatId: json['seat_id'],
      libraryId: json['library_id'],
    );
  }
}
