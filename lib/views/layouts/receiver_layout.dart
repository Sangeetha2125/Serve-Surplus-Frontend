import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/providers/location.dart';
import 'package:serve_surplus/services/location.dart';
import 'package:serve_surplus/views/receiver/orders.dart';
import 'package:serve_surplus/views/receiver/view_donations.dart';
import 'package:serve_surplus/views/user/profile.dart';

class ReceiverLayout extends StatefulWidget {
  static const String routeName = "/receiver";
  const ReceiverLayout({super.key});

  @override
  State<ReceiverLayout> createState() => _ReceiverLayoutState();
}

class _ReceiverLayoutState extends State<ReceiverLayout> {
  int _page = 0;

  final List<Widget> pages = [
    const ViewDonationsPage(),
    const ReceiverOrdersPage(),
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
              Icons.health_and_safety,
            ),
            label: 'View Donations',
            tooltip: "View Donations",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            label: 'My Orders',
            tooltip: "My Orders",
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
