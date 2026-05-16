import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';

abstract class BaseTripFormController extends ChangeNotifier {
  final MapControllerService mapService;

  BaseTripFormController(this.mapService);

  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final dateTimeController = TextEditingController();

  DateTime? selectedDateTime;

  double? pickupLat, pickupLon;
  double? dropLat, dropLon;

  bool isLoading = false;

  bool get pickUpAndDestinationValid =>
      pickupLat != null &&
      pickupLon != null &&
      dropLat != null &&
      dropLon != null;

  Future<void> pickDateTime(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    dateTimeController.text = formatDateTime(selectedDateTime!);

    notifyListeners();
  }

  void setPickupLocation({
    required double lat,
    required double lon,
    String? address,
  }) async {
    pickupLat = lat;
    pickupLon = lon;

    mapService.setPickupMarker(lat, lon);

    if (address != null) {
      pickupController.text = address;
    }

    mapService.moveCamera(lat, lon);

    if (dropLat != null && dropLon != null) {
      await mapService.drawRoute(lat, lon, dropLat!, dropLon!);
    }

    notifyListeners();
  }

  void setDropLocation({
    required double lat,
    required double lon,
    String? address,
  }) async {
    dropLat = lat;
    dropLon = lon;

    mapService.setDropMarker(lat, lon);

    if (address != null) {
      destinationController.text = address;
    }

    if (pickUpAndDestinationValid) {
      await mapService.drawRoute(pickupLat!, pickupLon!, dropLat!, dropLon!);
    }

    notifyListeners();
  }

  String formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }
}
