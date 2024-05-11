import 'package:flutter/material.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/services/receiver.dart';
import 'package:serve_surplus/widgets/custom_button.dart';

class ViewDonationsPage extends StatefulWidget {
  const ViewDonationsPage({super.key});

  @override
  State<ViewDonationsPage> createState() => _ViewDonationsPageState();
}

class _ViewDonationsPageState extends State<ViewDonationsPage> {
  List<Donation> donations = [];

  navigateToIndividualDonation(int index) {
    Navigator.pushNamed(
      context,
      '/individual-donation',
      arguments: {
        "donorId": donations[index].donor,
        "donation": donations[index],
      },
    );
  }

  getAllNearestDonations() async {
    donations = await ReceiverServices.getAllNearestDonations(context: context);
    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getAllNearestDonations();
  }

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
                        return GestureDetector(
                          onTap: () => navigateToIndividualDonation(index),
                          child: Container(
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
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: donations[index].distance! <= 5
                                              ? 140
                                              : donations[index].distance! < 10
                                                  ? 118
                                                  : 124,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 7,
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 0.3,
                                              color: Colors.white,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                constraints:
                                                    const BoxConstraints(
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
                                              Text(
                                                donations[index].distance! <= 5
                                                    ? "Near your place"
                                                    : "${donations[index].distance} kms away",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color: Color.fromARGB(
                                                  255, 8, 6, 135),
                                            ),
                                          ),
                                          Text(
                                            donations[index]
                                                .quantity
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      CustomButton(
                                        "View Donation",
                                        formKey: null,
                                        userService: () =>
                                            navigateToIndividualDonation(index),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
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
