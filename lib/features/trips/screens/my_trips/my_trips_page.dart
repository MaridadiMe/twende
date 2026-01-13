import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_controller.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/views/trips_view.dart';

class MyTripsPage extends StatefulWidget {
  final MyTripsController controller;
  const MyTripsPage({super.key, required this.controller});
  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  @override
  void initState() {
    super.initState();

    widget.controller.getUserTrips();
  }

  @override
  Widget build(BuildContext context) {
    return TripsView(controller: widget.controller);
  }
}
