import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/trips/components/trip_search_result_item.dart';
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

        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                controller.goToPreviousSheetView(BottomSheetView.searchForm),
          ),
        ),

        if (controller.trips.isEmpty) Center(child: Text("No trips found")),

        ...controller.trips.map((trip) {
          return TripSearchResultItem(trip: trip, controller: controller);
        }),
      ],
    );
  }
}
