import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/trips/models/trip.dart';
import 'package:flutter_application_1/features/trips/screens/driver/driver_trip_detail_screen.dart';
import 'package:flutter_application_1/features/trips/screens/driver/driver_trips_controller.dart';
import 'package:flutter_application_1/features/trips/screens/driver/schedule_trip_screen.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class DriverTrips extends StatefulWidget {
  const DriverTrips({super.key});

  @override
  State<DriverTrips> createState() => _DriverTripsState();
}

class _DriverTripsState extends State<DriverTrips> {
  late final DriverTripsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DriverTripsController(TripService(ApiClient()));
    _controller.loadTrips();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openScheduleTrip() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ScheduleTripScreen()),
    );
    if (result == true) _controller.loadTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openScheduleTrip,
        icon: const Icon(Icons.add),
        label: const Text('Schedule Trip'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _controller.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _controller.loadTrips,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_controller.trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No trips yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the button below to schedule your first trip',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.loadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: _controller.trips.length,
        itemBuilder: (_, index) {
          final trip = _controller.trips[index];
          return _TripCard(
            trip: trip,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DriverTripDetailScreen(trip: trip),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const _TripCard({required this.trip, this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'scheduled':
        return AppColors.success;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dt = trip.departureAt.toLocal();
    final dateStr =
        '${dt.day}/${dt.month}/${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(
                      trip.status,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    trip.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(trip.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.circle, size: 10, color: AppColors.success),
                    Container(width: 2, height: 24, color: Colors.grey[300]),
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.startAddress,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        trip.endAddress,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            Row(
              children: [
                _Stat(
                  icon: Icons.event_seat,
                  label:
                      '${trip.seatsAvailable}/${trip.seatsTotal} seats left',
                ),
                const SizedBox(width: 16),
                _Stat(
                  icon: Icons.payments_outlined,
                  label: 'TZS ${trip.price.toStringAsFixed(0)}',
                ),
                if (trip.bookings != null && trip.bookings!.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  _Stat(
                    icon: Icons.people,
                    label: '${trip.bookings!.length} booked',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Stat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
