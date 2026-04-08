import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerService {
  final Completer<GoogleMapController> controller = Completer();
  final PolylinePoints polylinePoints;
  final String apiKey;

  Set<Marker> get markers => _markers; // getter only
  Set<Polyline> get polylines => _polylines;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  MapControllerService(this.apiKey)
    : polylinePoints = PolylinePoints(apiKey: apiKey);

  Future<void> moveCamera(double lat, double lng) async {
    final c = await controller.future;
    c.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15));
  }

  Future<void> drawRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(startLat, startLng),
        destination: PointLatLng(endLat, endLng),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      final newPolyline = Polyline(
        polylineId: const PolylineId('route'),
        width: 5,
        color: Colors.blue, // ← add if missing
        points: result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(),
      );

      _polylines.clear();
      _polylines.add(newPolyline);

      await fitToRoute(startLat, startLng, endLat, endLng);
    } else {
      _polylines.clear();
      debugPrint('No route points received');
    }
  }

  void clearRoutes() {
    _polylines.clear();
  }

  void setPickupMarker(double lat, double lon) {
    _markers.removeWhere((m) => m.markerId.value == 'pickup');
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(lat, lon),
        infoWindow: const InfoWindow(title: 'Pickup location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  void setDropMarker(double lat, double lon) {
    _markers.removeWhere((m) => m.markerId.value == 'drop');
    _markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: LatLng(lat, lon),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> dispose() async {
    if (controller.isCompleted) {
      final futureController = await controller.future;
      futureController.dispose();
    }
  }

  Future<void> fitToRoute(
    double pickupLat,
    double pickupLon,
    double dropLat,
    double dropLon,
  ) async {
    final c = await controller.future;

    final bounds = LatLngBounds(
      southwest: LatLng(min(pickupLat, dropLat), min(pickupLon, dropLon)),
      northeast: LatLng(max(pickupLat, dropLat), max(pickupLon, dropLon)),
    );

    c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80)); // padding
  }

  // Future<Position> getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Location permissions are permanently denied.');
  //   }

  //   final locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.best, // replaces desiredAccuracy
  //     distanceFilter: 0, // optional, min distance for updates
  //   );

  //   return await Geolocator.getCurrentPosition(
  //     locationSettings: locationSettings,
  //   );
  // }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings(); // better UX
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // 🔥 HANDLE deniedForever FIRST
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );
  }
}
