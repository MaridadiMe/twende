import 'package:flutter/material.dart';
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
      controller: scrollController, // use it here
      padding: const EdgeInsets.all(16),
      children: [
        Text('Trip Results Form Sheet'),
        // add your search fields here...
      ],
    );
  }
}
