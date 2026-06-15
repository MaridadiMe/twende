import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/trips/controllers/driver_create_trip_controller.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/trip_map_view.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class ScheduleTripScreen extends StatefulWidget {
  const ScheduleTripScreen({super.key});

  @override
  State<ScheduleTripScreen> createState() => _ScheduleTripScreenState();
}

class _ScheduleTripScreenState extends State<ScheduleTripScreen> {
  static const String _googleApiKey = 'AIzaSyAkR1UUa5oJDKs92cX-BZsLkTAh86g9d6g';

  late final MapControllerService mapService;
  late final DriverCreateTripController controller;

  @override
  void initState() {
    super.initState();
    mapService = MapControllerService(_googleApiKey);
    controller = DriverCreateTripController(
      TripService(ApiClient()),
      mapService,
    );
  }

  @override
  void dispose() {
    mapService.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await controller.createTrip();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip scheduled successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to schedule trip. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule a Trip')),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (_, _) => TripMapView(mapService),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.2,
            maxChildSize: 0.88,
            builder: (_, scrollController) {
              return AnimatedBuilder(
                animation: controller,
                builder: (_, _) => _buildFormSheet(scrollController),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormSheet(ScrollController scrollController) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Text(
            'Trip Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GooglePlaceAutoCompleteTextField(
            textEditingController: controller.pickupController,
            googleAPIKey: _googleApiKey,
            inputDecoration: InputDecoration(
              hintText: 'Pickup location',
              prefixIcon: const Icon(
                Icons.my_location,
                color: AppColors.success,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            debounceTime: 400,
            countries: const ['tz'],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (prediction) {
              controller.setPickupLocation(
                lat: double.parse(prediction.lat!),
                lon: double.parse(prediction.lng!),
                address: prediction.description,
              );
            },
            itemClick: (prediction) {
              controller.pickupController.text = prediction.description!;
              controller.pickupController.selection =
                  TextSelection.fromPosition(
                TextPosition(offset: controller.pickupController.text.length),
              );
            },
          ),

          const SizedBox(height: 12),

          GooglePlaceAutoCompleteTextField(
            textEditingController: controller.destinationController,
            googleAPIKey: _googleApiKey,
            inputDecoration: InputDecoration(
              hintText: 'Destination',
              prefixIcon: const Icon(
                Icons.location_on,
                color: AppColors.error,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            debounceTime: 400,
            countries: const ['tz'],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (prediction) {
              controller.setDropLocation(
                lat: double.parse(prediction.lat!),
                lon: double.parse(prediction.lng!),
                address: prediction.description,
              );
            },
            itemClick: (prediction) {
              controller.destinationController.text = prediction.description!;
              controller.destinationController.selection =
                  TextSelection.fromPosition(
                TextPosition(
                  offset: controller.destinationController.text.length,
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: controller.dateTimeController,
            readOnly: true,
            onTap: () => controller.pickDateTime(context),
            decoration: InputDecoration(
              hintText: 'Departure date & time',
              prefixIcon: const Icon(Icons.calendar_today),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.seatsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Seats',
                    prefixIcon: const Icon(Icons.event_seat),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller.priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Price (TZS)',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed:
                controller.isFormValid && !controller.isLoading ? _submit : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: controller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Schedule Trip'),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
