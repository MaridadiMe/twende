import 'package:flutter_application_1/features/trips/models/trip_booking.dart';
import 'package:flutter_application_1/features/trips/models/trip_driver.dart';
import 'package:flutter_application_1/features/trips/models/trip_vehicle.dart';

class Trip {
  final String id;

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

  final TripDriver? driver;
  final TripVehicle? vehicle;
  final List<TripBooking>? bookings;

  Trip({
    required this.id,
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
    this.driver,
    this.vehicle,
    this.bookings,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],

      startLat: (json['startLat'] as num).toDouble(),
      startLon: (json['startLon'] as num).toDouble(),
      startAddress: json['startAddress'],

      endLat: (json['endLat'] as num).toDouble(),
      endLon: (json['endLon'] as num).toDouble(),
      endAddress: json['endAddress'],

      departureAt: DateTime.parse(json['departureAt']),
      seatsTotal: json['seatsTotal'],
      seatsAvailable: json['seatsAvailable'],
      price: (json['price'] as num).toDouble(),
      bookings: json['bookings'] != null
          ? (json['bookings'] as List)
                .map((bookingJson) => TripBooking.fromJson(bookingJson))
                .toList()
          : null,

      driver: json['driver'] != null
          ? TripDriver.fromJson(json['driver'])
          : null,

      vehicle: json['vehicle'] != null
          ? TripVehicle.fromJson(json['vehicle'])
          : null,
    );
  }
}
