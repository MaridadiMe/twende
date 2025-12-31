import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/enums/bottom_sheet_view.enum.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_controller.dart';

class TripResultsSheet extends StatelessWidget {
  final SearchTripController controller;
  final ScrollController scrollController;

  const TripResultsSheet({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
              controller.goToPreviousSheetView(BottomSheetView.searchForm),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back to search"),
        ),

        if (controller.trips.isEmpty) Center(child: Text("No trips found")),

        ...controller.trips.map((trip) {
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
                  "Departs: ${controller.formatDateTime(trip.departureAt)}",
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

              onTap: () => controller.selectTrip(trip),
            ),
          );
        }),
      ],
    );
  }
}
