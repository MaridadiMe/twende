import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/models/trip.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class DriverTripsController extends ChangeNotifier {
  final TripService tripService;

  List<Trip> trips = [];
  bool isLoading = false;
  String? error;

  DriverTripsController(this.tripService);

  Future<void> loadTrips() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      trips = await tripService.getDriverTrips();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
