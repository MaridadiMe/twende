class Booking {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;
  final String tripId;
  final String riderId;
  final String status;
  final int seats;

  Booking({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
    required this.tripId,
    required this.riderId,
    required this.status,
    required this.seats,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      tripId: json['tripId'],
      riderId: json['riderId'],
      seats: json['seats'],
      status: json['status'],
    );
  }
}
