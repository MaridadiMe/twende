import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/classes/session_manager.dart';
import 'package:flutter_application_1/features/trips/controllers/base_trip_form_controller.dart';
import 'package:flutter_application_1/features/trips/models/create_trip_request.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class DriverCreateTripController extends BaseTripFormController {
  final TripService tripService;

  DriverCreateTripController(this.tripService, MapControllerService mapService)
    : super(mapService);

  final seatsController = TextEditingController();
  final priceController = TextEditingController();

  bool get isFormValid =>
      pickUpAndDestinationValid &&
      selectedDateTime != null &&
      seatsController.text.isNotEmpty &&
      priceController.text.isNotEmpty;

  Future<bool> createTrip() async {
    try {
      isLoading = true;
      notifyListeners();

      await tripService.createTrip(
        CreateTripRequest(
          driverId: SessionManager.currentUser!.id,

          startLat: pickupLat!,
          startLon: pickupLon!,
          startAddress: pickupController.text,

          endLat: dropLat!,
          endLon: dropLon!,
          endAddress: destinationController.text,

          departureAt: selectedDateTime!.toUtc(),

          seatsTotal: int.parse(seatsController.text),

          seatsAvailable: int.parse(seatsController.text),

          price: double.parse(priceController.text),
        ),
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
