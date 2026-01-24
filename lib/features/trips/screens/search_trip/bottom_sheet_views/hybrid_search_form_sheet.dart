import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/components/trip_search_result_item.dart';
import 'package:flutter_application_1/features/trips/models/trip.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_controller.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class HybridSearchFormSheet extends StatelessWidget {
  final SearchTripController controller;
  final ScrollController scrollController;

  const HybridSearchFormSheet({
    required this.controller,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        /// Drag handle
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

        /// Toggle / Segmented control (default: Nearby)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: false,
                label: Text("Nearby Rides"),
                icon: Icon(Icons.near_me),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text("Custom Search"),
                icon: Icon(Icons.search),
              ),
            ],
            selected: {
              controller.showCustomSearch,
            }, // assuming bool showCustomSearch in controller (default false)
            onSelectionChanged: (newSelection) {
              final value = newSelection.first;
              controller.toggleSearchMode(
                value,
              ); // flip state & notifyListeners()
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black87,
              selectedBackgroundColor: Theme.of(context).primaryColor,
              selectedForegroundColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// Conditional content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.showCustomSearch
              ? _buildCustomSearchForm(
                  key: const ValueKey('search'),
                  context: context,
                )
              : _buildNearbyRidesList(key: const ValueKey('nearby')),
        ),
      ],
    );
  }

  Widget _buildCustomSearchForm({
    required Key key,
    required BuildContext context,
  }) {
    return Column(
      key: key,
      children: [
        /// Pickup field
        GooglePlaceAutoCompleteTextField(
          textEditingController: controller.pickupController,
          googleAPIKey: controller.mapService.apiKey,
          inputDecoration: InputDecoration(
            hintText: "Pickup location",
            prefixIcon: const Icon(Icons.location_on),
            filled: true,
            fillColor: Colors.grey[100],
            border: const OutlineInputBorder(),
          ),
          debounceTime: 400,
          countries: const ["tz"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {
            controller.setPickupLocation(
              lat: double.parse(prediction.lat!),
              lon: double.parse(prediction.lng!),
            );
          },
          itemClick: (prediction) {
            controller.pickupController.text = prediction.description!;
            controller.pickupController.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.pickupController.text.length),
            );
          },
        ),

        const SizedBox(height: 12),

        /// Destination field
        GooglePlaceAutoCompleteTextField(
          textEditingController: controller.destinationController,
          googleAPIKey: controller.mapService.apiKey,
          inputDecoration: InputDecoration(
            hintText: "Where to?",
            prefixIcon: const Icon(Icons.my_location),
            filled: true,
            fillColor: Colors.grey[100],
            border: const OutlineInputBorder(),
          ),
          debounceTime: 400,
          countries: const ["tz"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {
            controller.setDropLocation(
              lat: double.parse(prediction.lat!),
              lon: double.parse(prediction.lng!),
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

        /// Date and time picker
        TextField(
          controller: controller.dateTimeController,
          readOnly: true,
          onTap: () => controller.pickDateTime(context),
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

        const SizedBox(height: 24),

        /// Search button
        ElevatedButton(
          onPressed: controller.isFormValid && !controller.isLoading
              ? controller.searchTrips
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
          ),
          child: controller.isLoading
              ? const CircularProgressIndicator()
              : const Text("Search Trips"),
        ),
      ],
    );
  }

  Widget _buildNearbyRidesList({required Key key}) {
    return FutureBuilder<List<Trip>>(
      key: key,
      future: controller.fetchNearbyTrips(), // implement this in controller
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final trips = snapshot.data ?? [];
        if (trips.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                "No rides available nearby right now.\nTry again soon or use custom search.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                "Available nearby (${trips.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...trips.map(
              (trip) =>
                  TripSearchResultItem(trip: trip, controller: controller),
            ),
            const SizedBox(
              height: 80,
            ), // extra space so last item isn't cut off
          ],
        );
      },
    );
  }
}
