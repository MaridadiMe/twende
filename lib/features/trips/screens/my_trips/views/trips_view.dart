import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_controller.dart';

class TripsView extends StatelessWidget {
  final MyTripsController controller;
  const TripsView({super.key, required this.controller});

  // @override
  // Widget build(BuildContext context) {

  //   return AnimatedBuilder(
  //     animation: controller,
  //     builder: (context, _) {
  //       // Loading state
  //       if (controller.isLoading) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       // Empty state
  //       if (controller.userTrips.isEmpty) {
  //         return const Center(child: Text('Ready to view your trips?'));
  //       }

  //       // Trips list
  //       return ListView.separated(
  //         itemCount: controller.userTrips.length,
  //         separatorBuilder: (_, __) => const Divider(height: 1),
  //         itemBuilder: (context, index) {
  //           final trip = controller.userTrips[index];

  //           return ListTile(
  //             contentPadding: const EdgeInsets.symmetric(
  //               horizontal: 12,
  //               vertical: 6,
  //             ),

  //             leading: Icon(
  //               vehicleTypeIcon(trip.vehicle?.type),
  //               color: vehicleIconColor(trip.vehicle?.type),
  //               size: 22,
  //             ),

  //             title: Text(
  //               "${trip.startAddress} → ${trip.endAddress}",
  //               style: TextStyle(
  //                 color: Theme.of(context).textTheme.bodyMedium?.color,
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),

  //             subtitle: Padding(
  //               padding: const EdgeInsets.only(top: 6),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "${trip.vehicle?.registrationNumber ?? 'N/A'} | Departs: ${controller.formatDateTime(trip.departureAt)}",
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),

  //                   const SizedBox(height: 4),

  //                   Text(
  //                     "Status: ${trip.bookings?.first.status}",
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.green.shade700,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             trailing: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   "${trip.price} TZS",
  //                   style: const TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   "${trip.bookings?.first.seats} seat${trip.bookings?.first.seats == 1 ? '' : 's'}",
  //                   style: TextStyle(
  //                     fontSize: 11,
  //                     color: trip.seatsAvailable == 1
  //                         ? Colors.redAccent
  //                         : Colors.grey.shade600,
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             onTap: () => controller.selectTrip(trip),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          children: [
            // Empty state
            if (controller.userTrips.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Your Booked Trips Will Be Shown Here!'),
                ),
              ),

            // Trips
            ...controller.userTrips.map((trip) {
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
                          "${trip.vehicle?.registrationNumber ?? 'N/A'} | Trip Date: ${controller.formatDateTime(trip.departureAt)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        if (trip.bookings != null)
                          Text(
                            "Trip Status: ${trip.status}",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade700,
                            ),
                          ),
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
                        "${trip.bookings?.first.seats} seat${trip.bookings?.first.seats == 1 ? '' : 's'}",
                        style: TextStyle(
                          fontSize: 11,
                          color: trip.bookings?.first.seats == 10
                              ? Colors.redAccent
                              : Colors.green.shade700,
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
      },
    );
  }
}
