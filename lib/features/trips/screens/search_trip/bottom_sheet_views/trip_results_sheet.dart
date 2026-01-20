import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
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
    IconData vehicleTypeIcon(String? type) {
      if (type == null) return Icons.directions_car; // fallback
      switch (type.toLowerCase()) {
        case 'bus':
          return Icons.directions_bus;
        case 'suv':
        case 'sedan':
          return Icons.directions_car;
        case 'motorcycle':
          return Icons.motorcycle;
        default:
          return Icons.directions_car;
      }
    }

    Color vehicleIconColor(String? type) {
      switch (type?.toUpperCase()) {
        case 'BUS':
          return AppColors.accent; // highlight buses
        case 'TRUCK':
          return Colors.orangeAccent;
        default:
          return AppColors.primary; // cars and others
      }
    }

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
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            //
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              leading: Icon(
                vehicleTypeIcon(trip.vehicle?.type),
                color: vehicleIconColor(trip.vehicle?.type),
                size: 22,
              ),

              title: Text(
                "${trip.startAddress} → ${trip.endAddress}",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${trip.vehicle!.registrationNumber} |Departs: ${controller.formatUtcTimeToLocal(trip.departureAt)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),
                  ],
                ),
              ),

              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${trip.price} TZS",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${trip.seatsAvailable} seat${trip.seatsAvailable == 1 ? '' : 's'}",
                    style: TextStyle(
                      fontSize: 11,
                      color: trip.seatsAvailable == 1
                          ? Colors.redAccent
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              onTap: () => controller.selectTrip(trip),
            ),
          );
        }),
      ],
    );
  }
}
