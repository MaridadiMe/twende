import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';
import 'package:flutter_application_1/features/profile/profile_controller.dart';
import 'package:flutter_application_1/features/profile/profile_screen.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_controller.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_page.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_page.dart';
import 'package:flutter_application_1/features/trips/services/trip_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final ApiClient apiClient;
  late final TripService tripService;
  late final AuthService authService;

  late final MyTripsController myTripsController;
  late final ProfileController profileController;

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    apiClient = ApiClient();
    tripService = TripService(apiClient);
    authService = AuthService(apiClient);

    myTripsController = MyTripsController(apiClient, tripService);
    profileController = ProfileController(authService);

    _tabs = [
      const SearchTripPage(),
      const MyTripsPage(),
      ProfileScreen(controller: profileController),
    ];
  }

  @override
  void dispose() {
    myTripsController.dispose();
    profileController.dispose();
    super.dispose();
  }

  PreferredSizeWidget? _buildAppBar() {
    switch (_currentIndex) {
      case 1:
        return AppBar(title: const Text('My Trips'));
      case 2:
        return AppBar(title: const Text('Profile'));
      default:
        return null;
    }
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);

    // 🔄 refresh logic per tab
    if (index == 1) {
      myTripsController.refresh();
    }

    if (index == 2) {
      profileController.loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        height: 66,
        selectedIndex: _currentIndex,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        elevation: 8,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'My Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
