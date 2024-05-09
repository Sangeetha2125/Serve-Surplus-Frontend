import 'package:flutter/material.dart';
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
              Icons.health_and_safety,
            ),
            label: 'View Donations',
            tooltip: "View Donations",
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
