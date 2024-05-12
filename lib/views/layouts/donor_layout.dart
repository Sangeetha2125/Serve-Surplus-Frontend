import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/providers/location.dart';
import 'package:serve_surplus/services/location.dart';
import 'package:serve_surplus/views/donor/donation_history.dart';
import 'package:serve_surplus/views/donor/live_donations.dart';
import 'package:serve_surplus/views/donor/orders.dart';
import 'package:serve_surplus/views/user/profile.dart';

class DonorLayout extends StatefulWidget {
  static const String routeName = "/donor";
  const DonorLayout({super.key});

  @override
  State<DonorLayout> createState() => _DonorLayoutState();
}

class _DonorLayoutState extends State<DonorLayout> {
  int _page = 0;

  final List<Widget> pages = [
    const LiveDonationsPage(),
    const DonorOrdersPage(),
    const DonationHistoryPage(),
    const ProfilePage(),
  ];
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
    getLocationCoordinates();
  }

  void _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();

    if (!servicePermission) {
      debugPrint("Service Disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    _currentLocation = await Geolocator.getCurrentPosition();
    Provider.of<LocationProvider>(context, listen: false)
        .setLocation(_currentLocation);
    LocationServices.setUserLocation(context);
  }

  void getLocationCoordinates() {
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        selectedItemColor: Colors.black,
        onTap: (page) {
          setState(() {
            _page = page;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics,
            ),
            label: 'Live Donations',
            tooltip: "Live Donations",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.agriculture_outlined,
            ),
            label: 'Requests',
            tooltip: "View Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            label: 'History',
            tooltip: "View History",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
            ),
            label: 'My Account',
            tooltip: "My Account",
          ),
        ],
      ),
    );
  }
}
