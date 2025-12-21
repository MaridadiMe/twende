import 'package:flutter/material.dart';

class ScheduleTripScreen extends StatelessWidget {
  const ScheduleTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Trip')),
      body: const Center(child: Text('Welcome to the Schedule Trip Page!')),
    );
  }
}
