import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                fontSize: 20,
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
      });
}
