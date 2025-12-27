import 'package:flutter_application_1/features/booking/models/booking.dart';

import '../../../core/api/api_client.dart';
import '../models/trip.dart';

class TripService {
  final ApiClient _apiClient;

  TripService(this._apiClient);

  Future<List<Trip>> searchTrips({
    required double pickupLat,
    required double pickupLon,
    required double dropLat,
    required double dropLon,
    required DateTime departureFrom,
    required DateTime departureTo,
    required double radiusKm,
  }) async {
    final response = await _apiClient.dio.get(
      '/api/v1/fms/trips/search',
      queryParameters: {
        'pickupLat': pickupLat,
        'pickupLon': pickupLon,
        'dropLat': dropLat,
        'dropLon': dropLon,
        'departureFrom': departureFrom.toIso8601String(),
        'departureTo': departureTo.toIso8601String(),
        'radiusKm': radiusKm,
      },
    );

    final data = response.data['data'] as List;
    return data.map((e) => Trip.fromJson(e)).toList();
  }

  Future<Booking> bookTrip({required int seats, required String tripId}) async {
    final response = await _apiClient.dio.post(
      '/api/v1/fms/bookings',
      data: {'tripId': tripId, 'seats': seats},
    );

    final data = response.data['data'];
    return Booking.fromJson(data);
  }
}
