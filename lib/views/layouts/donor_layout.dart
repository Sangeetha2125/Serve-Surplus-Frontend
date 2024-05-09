import 'package:flutter/material.dart';
import 'package:serve_surplus/views/donor/donation_history.dart';
import 'package:serve_surplus/views/donor/live_donations.dart';
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
    const DonationHistoryPage(),
    const ProfilePage(),
  ];
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
              Icons.analytics,
            ),
            label: 'Live Donations',
            tooltip: "Live Donations",
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
