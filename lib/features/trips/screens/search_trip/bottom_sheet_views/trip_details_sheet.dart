import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/enums/bottom_sheet_view.enum.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_controller.dart';

class TripDetailsSheet extends StatelessWidget {
  final SearchTripController controller;
  final ScrollController scrollController;

  const TripDetailsSheet({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  // @override
  // Widget build(BuildContext context) {
  //   if (controller.selectedTrip == null) return const SizedBox();
  //   final trip = controller.selectedTrip!;

  //   return ListView(
  //     padding: const EdgeInsets.all(16),
  //     controller: scrollController,
  //     children: [
  //       Center(
  //         child: Container(
  //           width: 40,
  //           height: 4,
  //           margin: const EdgeInsets.only(bottom: 16),
  //           decoration: BoxDecoration(
  //             color: Colors.grey[400],
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //         ),
  //       ),
  //       TextButton.icon(
  //         onPressed: () =>
  //             controller.goToPreviousSheetView(BottomSheetView.results),
  //         icon: const Icon(Icons.arrow_back),
  //         label: const Text("Back to results"),
  //       ),
  //       const SizedBox(height: 12),

  //       Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         elevation: 2,
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Trip route and date
  //               Text(
  //                 "${trip.startAddress} → ${trip.endAddress}",
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 "Departure: ${controller.formatDateTime(trip.departureAt)}",
  //               ),

  //               // Driver Details Section
  //               const SizedBox(height: 16),
  //               Row(
  //                 children: [
  //                   // Placeholder for Driver Profile Picture
  //                   CircleAvatar(
  //                     radius: 20,
  //                     backgroundColor: Colors.grey[300],
  //                     child: const Icon(Icons.person, color: Colors.white),
  //                   ),
  //                   const SizedBox(width: 12),
  //                   // Driver Name and Rating
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Driver: John Doe", // Placeholder name
  //                         style: const TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       Row(
  //                         children: [
  //                           const Icon(
  //                             Icons.star,
  //                             color: Colors.amber,
  //                             size: 16,
  //                           ),
  //                           const SizedBox(width: 4),
  //                           Text("4.8"), // Placeholder rating
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),

  //               const SizedBox(height: 16),

  //               // Price and Available Seats
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "Price: ${trip.price.toStringAsFixed(2)} TZS",
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   Text(
  //                     "Seats Available: ${trip.seatsAvailable} / ${trip.seatsTotal}",
  //                     style: const TextStyle(fontSize: 14, color: Colors.grey),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),

  //               // Book Trip Button
  //               ElevatedButton(
  //                 onPressed: () {
  //                   // Proceed to booking
  //                   controller.bookTrip(trip: trip, seats: 1, context: context);
  //                 },
  //                 child: controller.isLoading
  //                     ? const CircularProgressIndicator()
  //                     : const Text("Book Trip"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (controller.selectedTrip == null) {
      return const SizedBox();
    }

    final trip = controller.selectedTrip!;

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

        /// Back button
        TextButton.icon(
          onPressed: () =>
              controller.goToPreviousSheetView(BottomSheetView.results),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back to results"),
        ),

        const SizedBox(height: 12),

        /// Trip details card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Route
                Text(
                  "${trip.startAddress} → ${trip.endAddress}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// Departure time
                Text(
                  "Departure: ${controller.formatDateTime(trip.departureAt)}",
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 16),

                /// Driver section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Driver: John Doe",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text("4.8"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// Price & seats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${trip.price.toStringAsFixed(0)} TZS",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6200EE),
                      ),
                    ),
                    Text(
                      "Seats: ${trip.seatsAvailable} / ${trip.seatsTotal}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                /// Book button (FULL WIDTH)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () {
                            controller.bookTrip(
                              trip: trip,
                              seats: 1,
                              context: context,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Book Trip",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
