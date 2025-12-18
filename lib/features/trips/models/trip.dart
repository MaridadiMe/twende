class Trip {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;
  final String driverId;
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
  final String status;

  Trip({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
    required this.driverId,
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
    required this.status,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      driverId: json['driverId'],
      startLat: (json['startLat'] as num).toDouble(),
      startLon: (json['startLon'] as num).toDouble(),
      startAddress: json['startAddress'],
      endLat: (json['endLat'] as num).toDouble(),
      endLon: (json['endLon'] as num).toDouble(),
      endAddress: json['endAddress'],
      departureAt: DateTime.parse(json['departureAt']),
      seatsTotal: json['seatsTotal'],
      seatsAvailable: json['seatsAvailable'],
      price: double.parse(json['price']), // price is a string in the API
      status: json['status'],
    );
  }
}
