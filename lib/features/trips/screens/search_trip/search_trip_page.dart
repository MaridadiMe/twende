import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/bottom_sheet_views/search_form_sheet.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/bottom_sheet_views/sheet_switcher.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/bottom_sheet_views/trip_details_sheet.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/bottom_sheet_views/trip_results_sheet.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/map_controller_service.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/map_layer/trip_map_view.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_controller.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class SearchTripPage extends StatefulWidget {
  const SearchTripPage({super.key});

  @override
  State<SearchTripPage> createState() => _SearchTripPageState();
}

class _SearchTripPageState extends State<SearchTripPage> {
  static String googleApiKey = 'AIzaSyAkR1UUa5oJDKs92cX-BZsLkTAh86g9d6g';
  static MapControllerService mapService = MapControllerService(googleApiKey);
  static ApiClient apiClient = ApiClient();
  static TripService tripService = TripService(apiClient);
  SearchTripController controller = SearchTripController(
    tripService,
    mapService,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TripMapView(mapService), // Your map widget
        DraggableScrollableSheet(
          initialChildSize: 0.25,
          minChildSize: 0.15,
          maxChildSize: 0.75,
          builder: (_, scrollController) {
            return AnimatedBuilder(
              animation: controller,
              builder: (_, _) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  child: SheetSwitcher(
                    currentView: controller.currentView,
                    scrollController: scrollController,
                    buildSearchForm: (sc) => SearchFormSheet(
                      controller: controller,
                      scrollController: sc,
                    ),
                    buildResults: (sc) => TripResultsSheet(
                      controller: controller,
                      scrollController: sc,
                    ),
                    buildDetails: (sc) => TripDetailsSheet(
                      controller: controller,
                      scrollController: sc,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
