import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/widgets/custom_textfield.dart';

Future<File?> pickImage() async {
  File? selectedImage;
  final picker = ImagePicker();
  try {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return selectedImage;
}

void addDonationDialog(
    {required BuildContext context, required Function donateFood}) {
  final GlobalKey<FormState> itemFormKey = GlobalKey<FormState>();
  final TextEditingController itemController = TextEditingController();
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Form(
          key: itemFormKey,
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(
              "Add Donation",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: CustomTextField(
              extraWidth: true,
              controller: itemController,
              keyboardType: TextInputType.number,
              label: "No. of items you wish to donate",
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (itemFormKey.currentState!.validate()) {
                    int items = int.parse(itemController.text);
                    if (items > 0) {
                      donateFood(items);
                    }
                  }
                },
                child: const Text(
                  "Proceed",
                  style: TextStyle(
                    color: Color.fromARGB(255, 7, 107, 11),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 14.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

void addAlertDonationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(
          Icons.info,
          size: 30,
        ),
        title: const Text(
          "Capture Food Image",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: const Text(
          "Food image is required for the donation to be made",
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 14.0),
              child: Text(
                "CANCEL",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        actionsPadding: const EdgeInsets.only(
          top: 8,
          bottom: 24,
          right: 16,
        ),
      );
    },
  );
}

void addOrderDialog(
    {required BuildContext context,
    required Donation donation,
    required Function orderFood}) {
  final GlobalKey<FormState> orderFormKey = GlobalKey<FormState>();
  final TextEditingController quantityController = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Form(
        key: orderFormKey,
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Request Donation",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: CustomTextField(
            extraWidth: true,
            controller: quantityController,
            keyboardType: TextInputType.number,
            isOrderModule: true,
            orderQuantity: donation.quantity,
            label: "No. of items you are in need of",
          ),
          actions: [
            InkWell(
              onTap: () {
                if (orderFormKey.currentState!.validate()) {
                  int quantity = int.parse(quantityController.text);
                  if (quantity > 0 && quantity <= donation.quantity) {
                    Navigator.pop(context);
                    orderFood(quantity);
                  }
                }
              },
              child: const Text(
                "Request Donation",
                style: TextStyle(
                  color: Color.fromARGB(255, 7, 107, 11),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 14.0),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void donationRequestDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(
          Icons.check_circle_outlined,
          size: 30,
          color: Color.fromARGB(255, 3, 136, 8),
        ),
        title: const Text(
          "Donation Requested",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: const Text(
          "Please check your mail for the OTP and provide it to the donor when you collect the donation.",
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        actionsPadding: const EdgeInsets.only(
          top: 8,
          bottom: 24,
        ),
      );
    },
  );
}

void orderConfirmDialog(
    {required BuildContext context, required String receiverName}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(
          Icons.check_circle_outlined,
          size: 30,
          color: Color.fromARGB(255, 3, 136, 8),
        ),
        title: const Text(
          "Order confirmation",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          "Your order to the receiver $receiverName has been placed successfully",
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        actionsPadding: const EdgeInsets.only(
          top: 8,
          bottom: 24,
        ),
      );
    },
  );
}
