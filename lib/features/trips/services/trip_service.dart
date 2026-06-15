import 'package:flutter_application_1/features/booking/models/booking.dart';
import 'package:flutter_application_1/features/trips/models/create_trip_request.dart';

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

  Future<List<Trip>> getNearbyTrips({
    required double pickupLat,
    required double pickupLon,
  }) async {
    final departureFrom = DateTime.now().toUtc();

    final response = await _apiClient.dio.get(
      '/api/v1/fms/trips/nearby',
      queryParameters: {
        'pickupLat': pickupLat,
        'pickupLon': pickupLon,
        'departureFrom': departureFrom.toIso8601String(),
      },
    );

    final data = response.data['data'] as List;
    return data.map((e) => Trip.fromJson(e)).toList();
  }

  Future<Booking> bookTrip({required int seats, required String tripId}) async {
    final response = await _apiClient.dio.post(
      '/api/v1/fms/trips/$tripId/bookings',
      data: {'tripId': tripId, 'seats': seats},
    );

    final data = response.data['data'];
    return Booking.fromJson(data);
  }

  //  cancelTrip
  Future<bool> createTrip(CreateTripRequest payload) async {
    await _apiClient.dio.post('/api/v1/fms/trips', data: payload.toJson());
    return true;
  }

  //  cancelTrip
  Future<bool> cancelTrip({
    required String tripId,
    required String bookingId,
  }) async {
    await _apiClient.dio.delete(
      '/api/v1/fms/trips/$tripId/bookings/$bookingId',
    );
    return true;
  }

  //  confirmTrip
  Future<bool> confirmTrip({
    required String tripId,
    required String bookingId,
    required String phoneNumber,
  }) async {
    await _apiClient.dio.post(
      '/api/v1/fms/trips/$tripId/bookings/$bookingId/pay?paymentMobileNumber=$phoneNumber',
    );
    return true;
  }

  Future<List<Trip>> getUserTrips() async {
    final response = await _apiClient.dio.get('/api/v1/fms/trips/mine');

    final data = response.data['data'];

    if (data == null || data is! List) {
      return [];
    }

    return data.map<Trip>((trip) => Trip.fromJson(trip)).toList();
  }

  Future<List<Trip>> getDriverTrips() async {
    final response = await _apiClient.dio.get('/api/v1/fms/trips/driver');

    final data = response.data['data'];

    if (data == null || data is! List) {
      return [];
    }

    return data.map<Trip>((trip) => Trip.fromJson(trip)).toList();
  }
}
