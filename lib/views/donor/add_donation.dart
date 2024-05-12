import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:serve_surplus/constants/utils.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/services/donor.dart';
import 'package:serve_surplus/widgets/custom_button.dart';
import 'package:serve_surplus/widgets/custom_textfield.dart';

class AddDonationPage extends StatefulWidget {
  static const String routeName = "/add-donation";
  final int items;
  const AddDonationPage({super.key, required this.items});

  @override
  State<AddDonationPage> createState() => _AddDonationPageState();
}

class _AddDonationPageState extends State<AddDonationPage> {
  List<Donation> donations = [];
  File? image;
  final GlobalKey<FormState> _addDonationKey = GlobalKey<FormState>();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void addDonation() async {
    if (image == null) {
      addAlertDonationDialog(context);
    } else {
      final donation = await DonorServices.addDonationItem(
        context: context,
        food: _foodController.text,
        quantity: int.parse(_quantityController.text),
        image: image!,
      );
      if (donation != null) {
        donations.add(donation);
        if (widget.items == donations.length) {
          if (context.mounted) {
            DonorServices.addDonation(
              context: context,
              donations: donations,
            );
          }
        } else {
          resetForm();
        }
      }
    }
  }

  void selectImage() async {
    File? file = await pickImage();
    setState(() {
      image = file;
    });
  }

  void resetForm() {
    setState(() {
      _foodController.text = "";
      _quantityController.text = "";
      image = null;
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    _quantityController.dispose();
    image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Add Donation",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: resetForm,
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addDonationKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: DottedBorder(
                          strokeWidth: 1.5,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(6),
                          dashPattern: const [8, 4],
                          strokeCap: StrokeCap.square,
                          child: const SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Capture Image",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: _foodController,
                  label: "Name of the Food",
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                  controller: _quantityController,
                  label: "Quantity",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomButton(
                  widget.items != donations.length + 1
                      ? "Proceed"
                      : "Donate Now",
                  formKey: _addDonationKey,
                  userService: addDonation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
