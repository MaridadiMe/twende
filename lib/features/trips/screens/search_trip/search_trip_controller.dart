import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/enums/bottom_sheet_view.enum.dart';
import 'package:flutter_application_1/features/trips/models/trip.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';
import 'package:geolocator/geolocator.dart';

class SearchTripController extends ChangeNotifier {
  final TripService tripService;
  late final MapControllerService mapService;

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

  DateTime get departureFrom => selectedDateTime!.toUtc();

  DateTime get departureTo =>
      selectedDateTime!.add(const Duration(minutes: 30)).toUtc();

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

  Future<List<Trip>>? nearbyTripsFuture;

  Future<void> loadNearbyTrips() async {
    nearbyTripsFuture = fetchNearbyTrips();
    notifyListeners();
  }

  Future<List<Trip>> fetchNearbyTrips() async {
    try {
      final Position position = await mapService.getCurrentLocation();
      pickupLat = position.latitude;
      pickupLon = position.longitude;

      final nearbyTrips = await tripService.getNearbyTrips(
        pickupLat: pickupLat!,
        pickupLon: pickupLon!, // now always non-null
      );
      return nearbyTrips;
    } catch (e) {
      debugPrint('Nearby trips fetch error: $e');
      return []; // or return [] and show error in UI
    } finally {
      isLoading = false;
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

  bool showCustomSearch = false; // default: show nearby list

  void toggleSearchMode(bool value) {
    showCustomSearch = value;
    notifyListeners();
  }

  void setDropLocation({
    required double lat,
    required double lon,
    String? address,
  }) async {
    // ← make async
    dropLat = lat;
    dropLon = lon;

    if (address != null) {
      destinationController.text = address;
      destinationController.selection = TextSelection.fromPosition(
        TextPosition(offset: destinationController.text.length),
      );
    }

    mapService.setDropMarker(lat, lon);

    if (pickUpAndDestinationValid) {
      debugPrint('Drawing route...');
      await mapService.drawRoute(pickupLat!, pickupLon!, dropLat!, dropLon!);
    }
    notifyListeners(); // ← crucial — this tells Consumer/Listener to rebuild
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
      pickupController.selection = TextSelection.fromPosition(
        TextPosition(offset: pickupController.text.length),
      );
    }

    mapService.moveCamera(lat, lon);

    // If drop is already set → draw route automatically
    if (dropLat != null && dropLon != null) {
      debugPrint('Pickup changed → redrawing route');
      await mapService.drawRoute(lat, lon, dropLat!, dropLon!);
    }

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

  String formatUtcTimeToLocal(DateTime utcDateTime) {
    final local = utcDateTime.toLocal();

    return "${local.day}/${local.month}/${local.year} "
        "${local.hour.toString().padLeft(2, '0')}:"
        "${local.minute.toString().padLeft(2, '0')}";
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

  Future<bool> bookTrip({required Trip trip, required int seats}) async {
    try {
      isLoading = true;
      await tripService.bookTrip(seats: 1, tripId: trip.id);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
