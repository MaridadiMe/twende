class TripBooking {
  final String id;
  final String status;
  final int seats;
  final DateTime bookedAt;
  final String? riderName;
  final String? riderPhone;

  TripBooking({
    required this.id,
    required this.status,
    required this.seats,
    required this.bookedAt,
    this.riderName,
    this.riderPhone,
  });

  factory TripBooking.fromJson(Map<String, dynamic> json) {
    return TripBooking(
      id: json['id'],
      status: json['status'],
      seats: json['seats'],
      bookedAt: DateTime.parse(json['bookedAt']),
      riderName: json['riderName'],
      riderPhone: json['riderPhone'],
    );
  }
}
