import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/trips/models/trip.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class MyTripsController extends ChangeNotifier {
  final ApiClient apiClient;
  final TripService tripService;

  MyTripsController(this.apiClient, this.tripService);

  List<Trip> userTrips = [];
  bool isLoading = false;
  Trip? selectedTrip;

  Future<void> getUserTrips() async {
    isLoading = true;
    notifyListeners();

    try {
      userTrips = await tripService.getUserTrips();
      debugPrint('');
    } catch (e) {
      userTrips = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  String formatUtcTimeToLocal(DateTime utcDateTime) {
    final local = utcDateTime.toLocal();

    return "${local.day}/${local.month}/${local.year} "
        "${local.hour.toString().padLeft(2, '0')}:"
        "${local.minute.toString().padLeft(2, '0')}";
  }

  void selectTrip(Trip trip) {
    selectedTrip = trip;
    notifyListeners();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();

    userTrips = await tripService.getUserTrips();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> cancelTrip({required Trip trip}) async {
    isLoading = true;
    notifyListeners();

    try {
      final booking = trip.bookings?.first.id ?? '';
      await tripService.cancelTrip(tripId: trip.id, bookingId: booking);
      userTrips.removeWhere((t) => t.id == trip.id);
      return true;
    } catch (e) {
      // Handle error if needed
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> payForTrip({
    required Trip trip,
    required String phoneNumber,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await tripService.payForTrip(tripId: trip.id, phoneNumber: phoneNumber);
      // Update trip status if needed
      return true;
    } catch (e) {
      // Handle error if needed
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
