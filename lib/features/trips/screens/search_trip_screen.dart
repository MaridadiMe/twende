import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/trip_service.dart';
import '../../../core/api/api_client.dart';

class SearchTripScreen extends StatefulWidget {
  const SearchTripScreen({super.key});

  @override
  State<SearchTripScreen> createState() => _SearchTripScreenState();
}

class _SearchTripScreenState extends State<SearchTripScreen> {
  final TextEditingController _pickupLatController = TextEditingController();
  final TextEditingController _pickupLonController = TextEditingController();
  final TextEditingController _dropLatController = TextEditingController();
  final TextEditingController _dropLonController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController(
    text: '1',
  );

  DateTime? _departureFrom;
  DateTime? _departureTo;

  bool _isLoading = false;
  List<Trip> _trips = [];

  final TripService _tripService = TripService(ApiClient());

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _departureFrom = picked.start;
        _departureTo = picked.end;
      });
    }
  }

  Future<void> _searchTrips() async {
    if (_pickupLatController.text.isEmpty ||
        _pickupLonController.text.isEmpty ||
        _dropLatController.text.isEmpty ||
        _dropLonController.text.isEmpty ||
        _departureFrom == null ||
        _departureTo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final trips = await _tripService.searchTrips(
        pickupLat: double.parse(_pickupLatController.text),
        pickupLon: double.parse(_pickupLonController.text),
        dropLat: double.parse(_dropLatController.text),
        dropLon: double.parse(_dropLonController.text),
        departureFrom: _departureFrom!,
        departureTo: _departureTo!,
        radiusKm: double.parse(_radiusController.text),
      );

      setState(() => _trips = trips);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error searching trips: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Trips')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pickupLatController,
              decoration: const InputDecoration(labelText: 'Pickup Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pickupLonController,
              decoration: const InputDecoration(labelText: 'Pickup Longitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dropLatController,
              decoration: const InputDecoration(labelText: 'Drop Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dropLonController,
              decoration: const InputDecoration(labelText: 'Drop Longitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _radiusController,
              decoration: const InputDecoration(labelText: 'Radius (km)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _departureFrom != null
                        ? 'From: ${_departureFrom!.toLocal()}'
                        : 'Select departure range',
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDateRange,
                  child: const Text('Pick Dates'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _searchTrips,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Search'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _trips.isEmpty
                  ? const Center(child: Text('No trips found'))
                  : ListView.builder(
                      itemCount: _trips.length,
                      itemBuilder: (_, index) {
                        final trip = _trips[index];
                        return Card(
                          child: ListTile(
                            title: Text('Driver: ${trip.driverId}'),
                            subtitle: Text(
                              'Departure: ${trip.departureAt}\nSeats: ${trip.seatsAvailable} | Price: ${trip.price}',
                            ),
                            onTap: () {
                              // TODO: Navigate to Trip Details / Booking
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
