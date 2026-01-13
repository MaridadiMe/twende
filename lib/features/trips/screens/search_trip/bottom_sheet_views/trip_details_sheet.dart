import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/enums/bottom_sheet_view.enum.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_controller.dart';

class TripDetailsSheet extends StatelessWidget {
  final SearchTripController controller;
  final ScrollController scrollController;
  final VoidCallback onBookingSuccess;

  const TripDetailsSheet({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.onBookingSuccess,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.selectedTrip == null) return const SizedBox();

    final trip = controller.selectedTrip!;
    final theme = Theme.of(context);

    IconData vehicleIcon = Icons.directions_car;
    switch (trip.vehicle?.type.toUpperCase()) {
      case 'BUS':
        vehicleIcon = Icons.directions_bus;
        break;
      case 'TRUCK':
        Icons.directions_car;
        break;
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsetsGeometry.directional(
        bottom: 12,
        start: 20,
        end: 20,
        top: 12,
      ),
      children: [
        /// Drag handle
        Center(
          child: Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        /// Back button
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                controller.goToPreviousSheetView(BottomSheetView.results),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          //
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      TimeOfDay.fromDateTime(trip.departureAt).format(context),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.startAddress,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Text(
                      TimeOfDay.fromDateTime(trip.departureAt).format(context),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.endAddress,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.grey),
                const SizedBox(height: 12),

                /// Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total price (1 passenger)"),
                    Text(
                      "TZS ${trip.price.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.grey),
                const SizedBox(height: 12),

                /// DRIVER SECTION
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.driver?.driverName ?? 'Unknown Driver',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(trip.driver?.rating?.toString() ?? 'N/A'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.grey),
                const SizedBox(height: 12),

                /// VEHICLE SECTION
                Row(
                  children: [
                    Icon(vehicleIcon, size: 28, color: theme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        trip.vehicle?.registrationNumber ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Seats",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Text(
                          "${trip.seatsAvailable} / ${trip.seatsTotal}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.grey),
                const SizedBox(height: 12),

                /// BOOK BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            final success = await controller.bookTrip(
                              trip: trip,
                              seats: 1,
                            );

                            if (success) {
                              onBookingSuccess();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Booking Successful: ')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking failed')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF00AEEF,
                      ), // BlaBlaCar-style blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Request to Book",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Route + time
      ],
    );
  }
}
