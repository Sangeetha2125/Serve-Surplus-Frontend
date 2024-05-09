import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/constants/http_response_handler.dart';
import 'package:serve_surplus/constants/secrets.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/schema/donation.dart';
import "package:http/http.dart" as http;

class DonorServices {
  static Future<Donation?> addDonationItem({
    required BuildContext context,
    required String food,
    required int quantity,
    required File image,
  }) async {
    final String imageUrl;
    final cloudinary =
        CloudinaryPublic(Secrets.cloudName, Secrets.uploadPreset);
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: "Serve-Surplus"));
      imageUrl = response.secureUrl;
      Donation donation =
          Donation(food: food, quantity: quantity, image: imageUrl);
      return donation;
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString(),
            ),
          ),
        );
      }
    }
    return null;
  }

  static void addDonation(
      {required BuildContext context,
      required List<Donation> donations}) async {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      List<Map<String, dynamic>> donationMaps =
          donations.map((donation) => donation.toMap()).toList();
      http.Response response = await http.patch(
        Uri.parse("https://serve-surplus.onrender.com/api/donor"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"donations": donationMaps}),
      );
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Donation added successfully"),
              ),
            );
          },
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
