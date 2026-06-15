class CreateTripRequest {
  final String driverUserId;

  final double startLat;
  final double startLon;
  final String startAddress;

  final double endLat;
  final double endLon;
  final String endAddress;

  final DateTime departureAt;

  final int seatsTotal;
  final int seatsAvailable;

  final double price;

  CreateTripRequest({
    required this.driverUserId,
    required this.startLat,
    required this.startLon,
    required this.startAddress,
    required this.endLat,
    required this.endLon,
    required this.endAddress,
    required this.departureAt,
    required this.seatsTotal,
    required this.seatsAvailable,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverUserId': driverUserId,
      'startLat': startLat,
      'startLon': startLon,
      'startAddress': startAddress,
      'endLat': endLat,
      'endLon': endLon,
      'endAddress': endAddress,
      'departureAt': departureAt.toIso8601String(),
      'seatsTotal': seatsTotal,
      'seatsAvailable': seatsAvailable,
      'price': price,
    };
  }
}
