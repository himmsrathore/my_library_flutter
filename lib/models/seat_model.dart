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
