import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/trips/enums/bottom_sheet_view.enum.dart';
import 'package:flutter_application_1/features/trips/models/trip.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class SearchTripController extends ChangeNotifier {
  final TripService tripService;
  final MapControllerService mapService;

  SearchTripController(this.tripService, this.mapService);

  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  final dateTimeController = TextEditingController();

  BottomSheetView currentView = BottomSheetView.searchForm;

  bool isLoading = false;
  DateTime? selectedDateTime;

  double? pickupLat, pickupLon;
  double? dropLat, dropLon;

  List<Trip> trips = [];
  Trip? selectedTrip;

  DateTime get departureFrom => selectedDateTime!;
  DateTime get departureTo =>
      selectedDateTime!.add(const Duration(minutes: 30));

  Future<void> searchTrips() async {
    if (!isFormValid) throw Exception('Invalid form');

    isLoading = true;
    notifyListeners();

    try {
      trips = await tripService.searchTrips(
        pickupLat: pickupLat!,
        pickupLon: pickupLon!,
        dropLat: dropLat!,
        dropLon: dropLon!,
        departureFrom: departureFrom,
        departureTo: departureTo,
        radiusKm: 3,
      );
      currentView = BottomSheetView.results;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool get isFormValid =>
      pickupLat != null &&
      pickupLon != null &&
      dropLat != null &&
      dropLon != null &&
      selectedDateTime != null;

  bool get pickUpAndDestinationValid =>
      pickupLat != null &&
      pickupLon != null &&
      dropLat != null &&
      dropLon != null;

  void setPickupLocation({
    required double lat,
    required double lon,
    String? address,
  }) {
    pickupLat = lat;
    pickupLon = lon;

    if (address != null) {
      pickupController.text = address;
      pickupController.selection = TextSelection.fromPosition(
        TextPosition(offset: pickupController.text.length),
      );
    }

    mapService.moveCamera(lat, lon);

    notifyListeners();
  }

  void setDropLocation({
    required double lat,
    required double lon,
    String? address,
  }) {
    dropLat = lat;
    dropLon = lon;

    if (address != null) {
      destinationController.text = address;
      destinationController.selection = TextSelection.fromPosition(
        TextPosition(offset: destinationController.text.length),
      );
    }

    if (pickUpAndDestinationValid) {
      mapService.drawRoute(pickupLat!, pickupLon!, dropLat!, dropLon!);
    }

    mapService.moveCamera(lat, lon);

    notifyListeners();
  }

  Future<void> pickDateTime(BuildContext context) async {
    final now = DateTime.now();

    /// Pick date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // no past dates
      lastDate: DateTime(now.year + 1),
    );

    if (date == null) return;

    /// Pick time
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final DateTime combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    selectedDateTime = combined;
    dateTimeController.text = formatDateTime(combined);

    notifyListeners();
  }

  String formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  void selectTrip(Trip trip) {
    selectedTrip = trip;
    currentView = BottomSheetView.details;
    notifyListeners();
  }

  void clearSelectedTrip() {
    selectedTrip = null;
    notifyListeners();
  }

  void goToPreviousSheetView(BottomSheetView previousView) {
    currentView = previousView;
    notifyListeners();
  }

  Future<void> bookTrip({
    required Trip trip,
    required int seats,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      final booking = await tripService.bookTrip(seats: 1, tripId: trip.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Successful: ${booking.id}')),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ApiClient.extractErrorMessage(e))));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
