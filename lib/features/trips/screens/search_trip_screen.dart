import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/enums/search_trip.enum.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import '../../../core/api/api_client.dart';
import 'package:geolocator/geolocator.dart';

class SearchTripScreen extends StatefulWidget {
  const SearchTripScreen({super.key});

  @override
  State<SearchTripScreen> createState() => _SearchTripScreen();
}

class _SearchTripScreen extends State<SearchTripScreen> {
  final TripService _tripService = TripService(ApiClient());
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.47,
  );

  final String googleApiKey = 'AIzaSyAkR1UUa5oJDKs92cX-BZsLkTAh86g9d6g';

  double? pickupLat;
  double? pickupLon;
  double? dropLat;
  double? dropLon;

  DateTime? selectedDateTime;
  DateTime get _departureFrom => selectedDateTime!;

  DateTime get _departureTo =>
      selectedDateTime!.add(const Duration(minutes: 30));

  bool _isLoading = false;
  List<Trip> _trips = [];

  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  final dateTimeController = TextEditingController();

  Future<void> _moveCamera(double lat, double lng) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15));
  }

  TripSheetView _currentView = TripSheetView.searchForm;

  Future<void> _pickDateTime() async {
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

    setState(() {
      selectedDateTime = combined;
      dateTimeController.text = _formatDateTime(combined);
    });
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _searchTrips() async {
    if (pickupLat == null ||
        pickupLon == null ||
        dropLat == null ||
        dropLon == null ||
        selectedDateTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final trips = await _tripService.searchTrips(
        pickupLat: pickupLat!,
        pickupLon: pickupLon!,
        dropLat: dropLat!,
        dropLon: dropLon!,
        departureFrom: _departureFrom,
        departureTo: _departureTo,
        radiusKm: 3, // Bolt-like default radius
      );

      setState(() {
        _trips = trips;
        _currentView = TripSheetView.results;
      });
    } catch (e) {
      setState(() => _currentView = TripSheetView.searchForm);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error searching trips: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  late PolylinePoints polylinePoints;

  Set<Polyline> _polylines = {};

  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
    polylinePoints = PolylinePoints(apiKey: googleApiKey);
  }

  Future<void> _setInitialLocation() async {
    final position = await _getCurrentLocation();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _drawRoute() async {
    if (pickupLat == null ||
        pickupLon == null ||
        dropLat == null ||
        dropLon == null) {
      return;
    }

    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pickupLat!, pickupLon!),
        destination: PointLatLng(dropLat!, dropLon!),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isEmpty) return;

    final points = result.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    final polyline = Polyline(
      polylineId: const PolylineId('trip_route'),
      color: Colors.blue,
      width: 5,
      points: points,
    );

    setState(() {
      _polylines = {polyline};
    });

    _fitMapToRoute(points);
  }

  Future<void> _fitMapToRoute(List<LatLng> points) async {
    final controller = await _controller.future;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final p in points) {
      minLat = minLat < p.latitude ? minLat : p.latitude;
      maxLat = maxLat > p.latitude ? maxLat : p.latitude;
      minLng = minLng < p.longitude ? minLng : p.longitude;
      maxLng = maxLng > p.longitude ? maxLng : p.longitude;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        60,
      ),
    );
  }

  void _drawAndSearch() {
    _drawRoute();
    _searchTrips();
  }

  Widget _buildTripResults(ScrollController scrollController) {
    // if (_trips.isEmpty) {
    //   return const Center(child: Text("No trips found"));
    // }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        /// drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        TextButton.icon(
          onPressed: () =>
              setState(() => _currentView = TripSheetView.searchForm),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back to search"),
        ),

        if (_trips.isEmpty) Center(child: Text("No trips found")),

        ..._trips.map((trip) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              leading: const Icon(
                Icons.directions_car,
                color: Color(0xFF6200EE),
                size: 22,
              ),

              title: Text(
                "${trip.startAddress} → ${trip.endAddress}",
                style: const TextStyle(
                  fontSize: 14, // ↓ smaller than default
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "Departs: ${_formatDateTime(trip.departureAt)}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),

              trailing: Text(
                "${trip.price} TZS",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              onTap: () => setState(() {
                _selectedTrip = trip;
                _currentView = TripSheetView.details;
              }),
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Trip? _selectedTrip;

  Future<void> _bookTrip(Trip trip, int seats) async {
    try {
      final booking = await _tripService.bookTrip(seats: 1, tripId: trip.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Successful: ${booking.id}')),
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ApiClient.extractErrorMessage(e))));
    }
  }

  // Widget _buildBottomSheetContent(
  //   BuildContext context,
  //   ScrollController scrollController,
  // ) {
  //   switch (_currentView) {
  //     case TripSheetView.searchForm:
  //       return _buildSearchForm(context, scrollController);

  //     case TripSheetView.loading:
  //       return const Center(
  //         child: Padding(
  //           padding: EdgeInsets.all(24),
  //           child: CircularProgressIndicator(),
  //         ),
  //       );

  //     case TripSheetView.results:
  //       return _buildTripResults(scrollController);

  //     default:
  //       return _buildSearchForm(context, scrollController);
  //   }
  // }

  Widget _buildTripDetails(ScrollController scrollController) {
    if (_selectedTrip == null) return const SizedBox();

    final trip = _selectedTrip!;

    return ListView(
      padding: const EdgeInsets.all(16),
      controller: scrollController,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => setState(() => _currentView = TripSheetView.results),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back to results"),
        ),
        const SizedBox(height: 12),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip route and date
                Text(
                  "${trip.startAddress} → ${trip.endAddress}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Departure: ${_formatDateTime(trip.departureAt)}"),

                // Driver Details Section
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Placeholder for Driver Profile Picture
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    // Driver Name and Rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Driver: John Doe", // Placeholder name
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text("4.8"), // Placeholder rating
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price and Available Seats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: ${trip.price.toStringAsFixed(2)} TZS",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Seats Available: ${trip.seatsAvailable} / ${trip.seatsTotal}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Book Trip Button
                ElevatedButton(
                  onPressed: () {
                    // Proceed to booking
                    _bookTrip(trip, 1);
                  },
                  child: const Text("Book Trip"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheetContent(
    BuildContext context,
    ScrollController scrollController,
  ) {
    switch (_currentView) {
      case TripSheetView.searchForm:
        return _buildSearchForm(context, scrollController);
      case TripSheetView.results:
        return _buildTripResults(scrollController);
      case TripSheetView.details:
        return _buildTripDetails(scrollController);
      default:
        return _buildSearchForm(context, scrollController);
    }
  }

  Widget _buildSearchForm(
    BuildContext context,
    ScrollController scrollController,
  ) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        /// drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        /// pickup field
        GooglePlaceAutoCompleteTextField(
          textEditingController: pickupController,
          googleAPIKey: googleApiKey,
          inputDecoration: InputDecoration(
            hintText: "Pickup location",
            prefixIcon: const Icon(Icons.my_location),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          debounceTime: 400,
          countries: const ["tz"], // Tanzania
          isLatLngRequired: true,

          getPlaceDetailWithLatLng: (prediction) {
            final lat = double.parse(prediction.lat!);
            final lng = double.parse(prediction.lng!);

            setState(() {
              pickupLat = lat;
              pickupLon = lng;
            });

            _moveCamera(lat, lng);
          },

          itemClick: (prediction) {
            pickupController.text = prediction.description!;
            pickupController.selection = TextSelection.fromPosition(
              TextPosition(offset: pickupController.text.length),
            );
          },
        ),

        /// destination field
        const SizedBox(height: 12),

        GooglePlaceAutoCompleteTextField(
          textEditingController: destinationController,
          googleAPIKey: googleApiKey,
          inputDecoration: InputDecoration(
            hintText: "Where to?",
            prefixIcon: const Icon(Icons.location_on),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          debounceTime: 400,
          countries: const ["tz"],
          isLatLngRequired: true,

          getPlaceDetailWithLatLng: (prediction) {
            final lat = double.parse(prediction.lat!);
            final lng = double.parse(prediction.lng!);

            setState(() {
              dropLat = lat;
              dropLon = lng;
            });

            _moveCamera(lat, lng);
          },

          itemClick: (prediction) {
            destinationController.text = prediction.description!;
            destinationController.selection = TextSelection.fromPosition(
              TextPosition(offset: destinationController.text.length),
            );
          },
        ),

        const SizedBox(height: 12),

        /// destination field
        TextField(
          decoration: InputDecoration(
            hintText: "Driver Distance?",
            prefixIcon: const Icon(Icons.radar),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// destination field
        TextField(
          controller: dateTimeController,
          readOnly: true, // important
          onTap: _pickDateTime,
          decoration: InputDecoration(
            hintText: "Date and Time?",
            prefixIcon: const Icon(Icons.calendar_month),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: _isLoading ? null : _drawAndSearch,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text("Search Trips"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 1️⃣ Map in the background
          GoogleMap(
            mapType: MapType.normal,
            polylines: _polylines,
            initialCameraPosition: CameraPosition(
              target:
                  _currentLocation ??
                  LatLng(
                    -6.7726389,
                    39.2170875,
                  ), // fallback if location not ready
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          /// 2️⃣ Bolt-style bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.25, // collapsed height
            minChildSize: 0.15,
            maxChildSize: 0.75, // expanded height
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: _buildBottomSheetContent(context, scrollController),
              );
            },
          ),
        ],
      ),
    );
  }
}
