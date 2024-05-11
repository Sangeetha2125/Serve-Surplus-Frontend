import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/services/receiver.dart';
import 'package:serve_surplus/widgets/custom_button.dart';

class IndividualDonationPage extends StatefulWidget {
  static const String routeName = "/individual-donation";
  final String donorId;
  final Donation donation;
  const IndividualDonationPage(
      {super.key, required this.donorId, required this.donation});

  @override
  State<IndividualDonationPage> createState() => _IndividualDonationPageState();
}

class _IndividualDonationPageState extends State<IndividualDonationPage> {
  Map<String, dynamic>? donor;
  @override
  void initState() {
    getDonorDetails();
    super.initState();
  }

  getDonorDetails() async {
    donor = await ReceiverServices.getDonorDetails(
      context: context,
      donorId: widget.donorId,
    );
    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: donor == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                      child: Image.network(
                        widget.donation.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.donation.food,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Quantity: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 8, 6, 135),
                                ),
                              ),
                              Text(
                                widget.donation.quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                "Donated on: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 135, 12, 6),
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, yyyy - h:mm a')
                                    .format(widget.donation.donatedAt!),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Divider(),
                          const Text(
                            "Donor Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(
                              12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              color: Colors.grey.shade100,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Name: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${donor!["name"]}",
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Phone number: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${donor!["phone"]}",
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Address: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          height: 1.75,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${donor!["doorNumber"]}, ${donor!["street"]}, ${donor!["area"]}, ${donor!["city"]} - ${donor!["pincode"]}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 6,
                          ),
                          CustomButton(
                            "Request Donation",
                            formKey: null,
                            userService: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}