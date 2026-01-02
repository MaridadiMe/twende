import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/screens/my_trips/my_trips_page.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip/search_trip_page.dart';
import '../trips/screens/schedule_trip_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const SearchTripPage(),
    const MyTripsPage(),
    const ScheduleTripScreen(),
  ];

  PreferredSizeWidget? _buildAppBar() {
    if (_currentIndex == 0) return null;
    switch (_currentIndex) {
      case 1:
        return AppBar(title: const Text('My Trips'));
      case 2:
        return AppBar(title: const Text('Profile'));
      default:
        return null;
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

        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },

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
