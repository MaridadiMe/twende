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
}
