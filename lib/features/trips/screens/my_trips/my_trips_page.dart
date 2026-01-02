import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_controller.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/views/trips_view.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});
  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  final ApiClient apiClient = ApiClient();
  late final TripService tripService;
  late final MyTripsController controller;

  @override
  void initState() {
    super.initState();
    tripService = TripService(apiClient);
    controller = MyTripsController(apiClient, tripService);

    controller.getUserTrips(); // 🔥 called once on page load
  }

  @override
  Widget build(BuildContext context) {
    return TripsView(controller: controller);
  }
}
