import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerService {
  final Completer<GoogleMapController> controller = Completer();
  final PolylinePoints polylinePoints;
  final String apiKey;

  Set<Polyline> polylines = {};

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

    if (result.points.isEmpty) return;

    polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        width: 5,
        points: result.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(),
      ),
    };
  }
}
