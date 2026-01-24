import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_controller.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class SearchFormSheet extends StatelessWidget {
  final SearchTripController controller;
  final ScrollController scrollController;

  const SearchFormSheet({
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

        /// Pickup field
        GooglePlaceAutoCompleteTextField(
          textEditingController: controller.pickupController,
          googleAPIKey: controller.mapService.apiKey,
          inputDecoration: InputDecoration(
            hintText: "Pickup location",
            prefixIcon: const Icon(Icons.location_on),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(),
          ),
          debounceTime: 400,
          countries: const ["tz"], // Tanzania
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

        GooglePlaceAutoCompleteTextField(
          textEditingController: controller.destinationController,
          googleAPIKey: controller.mapService.apiKey,
          inputDecoration: InputDecoration(
            hintText: "Where to?",
            prefixIcon: const Icon(Icons.my_location),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(),
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

        const SizedBox(height: 20),

        /// Search button
        ElevatedButton(
          onPressed: controller.isFormValid && !controller.isLoading
              ? controller.searchTrips
              : null,
          child: controller.isLoading
              ? const CircularProgressIndicator()
              : const Text("Search Trips"),
        ),
      ],
    );
  }
}
