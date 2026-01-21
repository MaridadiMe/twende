import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerService {
  final Completer<GoogleMapController> controller = Completer();
  final PolylinePoints polylinePoints;
  final String apiKey;

  Set<Polyline> polylines = {};
  final Set<Marker> markers = {};

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

  void clearRoutes() {
    polylines.clear();
  }

  void setPickupMarker(double lat, double lon) {
    markers.removeWhere((m) => m.markerId.value == 'pickup');
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(lat, lon),
        infoWindow: const InfoWindow(title: 'Pickup location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  void setDropMarker(double lat, double lon) {
    markers.removeWhere((m) => m.markerId.value == 'drop');

    markers.add(
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
}
