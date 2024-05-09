import 'package:flutter/material.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/services/donor.dart';

class DonationHistoryPage extends StatefulWidget {
  static const String routeName = "/donation-history";
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  List<Donation> donations = [];
  getDonationHistory() async {
    donations = await DonorServices.getDonationHistory(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDonationHistory();
  }

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
      body: SingleChildScrollView(
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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          donations[index].image,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12).copyWith(
                            bottom: 8,
                          ),
                          child: Text(
                            donations[index].food,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12).copyWith(top: 0),
                          child: Row(
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 8, 6, 135),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                donations[index].quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
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
