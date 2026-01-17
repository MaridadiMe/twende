import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_controller.dart';

class TripsView extends StatelessWidget {
  final MyTripsController controller;
  const TripsView({super.key, required this.controller});

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

        return RefreshIndicator(
          onRefresh: controller.getUserTrips,
          child: ListView(
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

                          Text(
                            "Trip: ${trip.status} | Booking: ${trip.bookings?.first.status}",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          if (trip.bookings?.first.status ==
                              'RESERVED') // or 'BOOKED' if you rename
                            Column(
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Cancel button - secondary
                                    SizedBox(
                                      width: 100,
                                      height: 25,
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          final success = await controller
                                              .cancelTrip(trip: trip);
                                          if (success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text('Trip cancelled'),
                                              ),
                                            );
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.redAccent,
                                          ), // border color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors
                                                .redAccent, // text matches border
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    // Pay button - primary action
                                    SizedBox(
                                      width: 100,
                                      height: 25,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final success = await controller
                                              .payForTrip(
                                                trip: trip,
                                                phoneNumber: '123',
                                              );
                                          if (success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Payment successful',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "TZS",
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "${trip.price}",
                          style: const TextStyle(
                            fontSize: 12,
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
          ),
        );
      },
    );
  }
}
