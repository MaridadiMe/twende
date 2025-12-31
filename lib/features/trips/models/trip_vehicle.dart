class TripVehicle {
  final String id;
  final String registrationNumber;
  final String type;

  TripVehicle({
    required this.id,
    required this.registrationNumber,
    required this.type,
  });

  factory TripVehicle.fromJson(Map<String, dynamic> json) {
    return TripVehicle(
      id: json['id'],
      registrationNumber: json['registrationNumber'],
      type: json['type'],
    );
  }
}
