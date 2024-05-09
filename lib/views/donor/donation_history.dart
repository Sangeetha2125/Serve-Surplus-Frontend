import 'package:flutter/material.dart';

class DonationHistoryPage extends StatelessWidget {
  static const String routeName = "/donation-history";
  const DonationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Donation History",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
