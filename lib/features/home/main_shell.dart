import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/auth/classes/app_state.dart';
import 'package:flutter_application_1/features/auth/enums/app_mode.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/trips/screens/driver/driver_dashboard.dart';
import 'package:flutter_application_1/features/trips/screens/driver/driver_trips.dart';
import 'package:flutter_application_1/features/profile/profile_controller.dart';
import 'package:flutter_application_1/features/profile/profile_screen.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_controller.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_page.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_page.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final ApiClient apiClient;
  late final TripService tripService;
  late final AuthService authService;

  late final MyTripsController myTripsController;
  late final ProfileController profileController;

  late List<_NavItem> _items;

  @override
  void initState() {
    super.initState();

    apiClient = ApiClient();
    tripService = TripService(apiClient);
    authService = AuthService(apiClient);

    myTripsController = MyTripsController(apiClient, tripService, authService);
    profileController = ProfileController(authService)..init();

    _buildNavigation();
  }

  void switchToMyTrips() {
    _onTabSelected(1);
  }

  @override
  void dispose() {
    myTripsController.dispose();
    profileController.dispose();
    super.dispose();
  }

  void _buildNavigation() {
    final mode = AppState.mode;

    if (mode == AppMode.driver) {
      _items = [
        _NavItem(
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          label: 'Dashboard',
          appBarTitle: 'Dashboard',
          page: const DriverDashboard(),
        ),
        _NavItem(
          icon: Icons.route_outlined,
          activeIcon: Icons.route,
          label: 'Trips',
          appBarTitle: 'My Trips',
          page: const DriverTrips(),
        ),
        _NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          appBarTitle: 'Profile',
          page: ProfileScreen(controller: profileController),
        ),
      ];
    } else {
      _items = [
        _NavItem(
          icon: Icons.search_outlined,
          activeIcon: Icons.search,
          label: 'Search',
          showAppBar: false,
          page: SearchTripPage(onBookingSuccess: switchToMyTrips),
        ),
        _NavItem(
          icon: Icons.route_outlined,
          activeIcon: Icons.route,
          label: 'My Trips',
          appBarTitle: 'My Trips',
          page: MyTripsPage(controller: myTripsController),
        ),
        _NavItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: 'Profile',
          appBarTitle: 'Profile',
          page: ProfileScreen(controller: profileController),
        ),
      ];
    }
  }

  PreferredSizeWidget? _buildAppBar() {
    final item = _items[_currentIndex];

    if (!item.showAppBar) {
      return null;
    }

    return AppBar(title: Text(item.appBarTitle ?? item.label));
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _items.map((e) => e.page).toList(),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        height: 66,
        destinations: _items
            .map(
              (e) => NavigationDestination(
                icon: Icon(e.icon),
                selectedIcon: Icon(e.activeIcon),
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget page;

  final String? appBarTitle;
  final bool showAppBar;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.page,
    this.appBarTitle,
    this.showAppBar = true,
  });
}
