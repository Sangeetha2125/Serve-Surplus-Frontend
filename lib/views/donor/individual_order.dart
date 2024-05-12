import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serve_surplus/constants/utils.dart';
import 'package:serve_surplus/schema/order.dart';
import 'package:serve_surplus/services/donor.dart';
import 'package:serve_surplus/widgets/custom_button.dart';

class IndividualDonorOrderPage extends StatefulWidget {
  static const String routeName = "/individual-receiver-order";
  final Order order;
  const IndividualDonorOrderPage({super.key, required this.order});

  @override
  State<IndividualDonorOrderPage> createState() =>
      _IndividualDonorOrderPageState();
}

class _IndividualDonorOrderPageState extends State<IndividualDonorOrderPage> {
  Map<String, dynamic>? receiver;
  @override
  void initState() {
    getReceiverDetails();
    super.initState();
  }

  getReceiverDetails() async {
    receiver = await DonorServices.getReceiverDetails(
      context: context,
      receiverId: widget.order.receiver_id,
    );
    if (context.mounted) {
      setState(() {});
    }
  }

  confirmOrder() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: receiver == null
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
                        widget.order.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
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
                            widget.order.food,
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
                                widget.order.quantity.toString(),
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
                                "Ordered on: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 135, 12, 6),
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, yyyy - h:mm a')
                                    .format(widget.order.date),
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
                            "Receiver Details",
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
                                      "${receiver!["name"]}",
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
                                      "${receiver!["phone"]}",
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
                                            "${receiver!["doorNumber"]}, ${receiver!["street"]}, ${receiver!["area"]}, ${receiver!["city"]} - ${receiver!["pincode"]}",
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
                            "Confirm Order",
                            formKey: null,
                            userService: () => orderConfirmDialog(
                              context: context,
                              confirmOrder: confirmOrder,
                            ),
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
