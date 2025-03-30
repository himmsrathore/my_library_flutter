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
      id: json['id'] ?? 0, // ✅ Default value to prevent null errors
      studentId: json['student_id'] ?? 0, // ✅ Default value
      dateAttended: json['date_attended'] ?? 'Unknown Date', // ✅ Default value
      checkIn: json['check_in'] ?? 'Unknown', // ✅ Default value
      checkOut: json['check_out'], // Nullable, no need for default
      seatId: json['seat_id'] ?? 0, // ✅ Default value
      libraryId: json['library_id'] ?? 0, // ✅ Default value
    );
  }
}
