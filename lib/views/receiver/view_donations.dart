import 'package:flutter/material.dart';

class ViewDonationsPage extends StatelessWidget {
  const ViewDonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "View Donations",
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
