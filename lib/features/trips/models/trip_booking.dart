class TripBooking {
  final String id;
  final String status;
  final int seats;
  final DateTime bookedAt;

  TripBooking({
    required this.id,
    required this.status,
    required this.seats,
    required this.bookedAt,
  });

  factory TripBooking.fromJson(Map<String, dynamic> json) {
    return TripBooking(
      id: json['id'],
      status: json['status'],
      seats: json['seats'],
      bookedAt: DateTime.parse(json['bookedAt']),
    );
  }
}
