import 'package:flutter/material.dart';
import 'package:serve_surplus/constants/utils.dart';
import 'package:serve_surplus/views/donor/add_donation.dart';

class LiveDonationsPage extends StatefulWidget {
  const LiveDonationsPage({super.key});

  @override
  State<LiveDonationsPage> createState() => _LiveDonationsPageState();
}

class _LiveDonationsPageState extends State<LiveDonationsPage> {
  void donateFood(int noOfItems) {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      AddDonationPage.routeName,
      arguments: noOfItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Live Donations",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                addDonationDialog(context: context, donateFood: donateFood),
            icon: const Icon(
              Icons.add_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
