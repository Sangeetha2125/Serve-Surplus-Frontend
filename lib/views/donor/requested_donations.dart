import 'package:flutter/material.dart';

class RequestedDonations extends StatefulWidget {
  const RequestedDonations({super.key});

  @override
  State<RequestedDonations> createState() => _RequestedDonationsState();
}

class _RequestedDonationsState extends State<RequestedDonations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Requested Donations",
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
