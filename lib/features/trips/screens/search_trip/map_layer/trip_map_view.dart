import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripMapView extends StatefulWidget {
  final MapControllerService mapService;

  const TripMapView(this.mapService, {super.key});

  @override
  State<TripMapView> createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    // _initCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCurrentLocation();
    });
  }

  @override
  void dispose() {
    widget.mapService.dispose(); // Clean up map controller
    super.dispose();
  }

  Future<void> _initCurrentLocation() async {
    try {
      final position = await widget.mapService.getCurrentLocation();

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Move camera to current location if controller is ready
      if (widget.mapService.controller.isCompleted) {
        widget.mapService.moveCamera(position.latitude, position.longitude);
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');

      if (e.toString().contains('permanently denied')) {
        Geolocator.openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _currentLocation ?? const LatLng(-6.7726389, 39.2170875),
        zoom: 15,
      ),
      polylines: widget.mapService.polylines,
      markers: widget.mapService.markers,
      onMapCreated: (controller) {
        if (!widget.mapService.controller.isCompleted) {
          widget.mapService.controller.complete(controller);
        }
      },
      myLocationEnabled: _currentLocation != null,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
    );
  }
}
