class TripDriver {
  final String id;
  final String driverName;
  final double? rating;
  final double? reviews;
  final String? photoUrl;

  TripDriver({
    required this.id,
    required this.driverName,
    this.rating,
    this.reviews,
    this.photoUrl,
  });

  factory TripDriver.fromJson(Map<String, dynamic> json) {
    return TripDriver(
      id: json['id'],
      driverName: json['driverName'],
      rating: json['rating']?.toDouble(),
      reviews: json['reviews']?.toDouble(),
      photoUrl: json['photoUrl'],
    );
  }
}
