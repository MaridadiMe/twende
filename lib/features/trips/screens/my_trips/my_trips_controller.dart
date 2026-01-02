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
    notifyListeners(); // 🔥 tell UI to show loader

    try {
      userTrips = await tripService.getUserTrips();
    } catch (e) {
      userTrips = [];
      // optionally store error message
    } finally {
      isLoading = false;
      notifyListeners(); // 🔥 tell UI to rebuild
    }
  }

  String formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
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
}
