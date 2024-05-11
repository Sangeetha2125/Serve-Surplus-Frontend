import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serve_surplus/constants/utils.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/services/donor.dart';
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

  List<Donation> donations = [];
  getLiveDonations() async {
    donations = await DonorServices.getLiveDonations(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getLiveDonations();
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
      body: donations.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: donations.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(13)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12)),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      donations[index].image,
                                      width: double.infinity,
                                      height: 170,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return SizedBox(
                                          height: 170,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 74,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 5,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 8,
                                                minHeight: 8,
                                              ),
                                              child: const SizedBox(
                                                width: 1,
                                                height: 1,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            const Text(
                                              "Live",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      donations[index].food,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Quantity: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Color.fromARGB(255, 8, 6, 135),
                                          ),
                                        ),
                                        Text(
                                          donations[index].quantity.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Donated on: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Color.fromARGB(255, 135, 12, 6),
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM d, yyyy - h:mm a')
                                              .format(
                                                  donations[index].donatedAt!),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
