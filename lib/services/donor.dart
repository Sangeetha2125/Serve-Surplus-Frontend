import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/constants/http_response_handler.dart';
import 'package:serve_surplus/constants/secrets.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/schema/donation.dart';
import "package:http/http.dart" as http;
import 'package:serve_surplus/schema/order.dart';

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

  static void addDonation({
    required BuildContext context,
    required List<Donation> donations,
  }) async {
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
        body: jsonEncode({
          "donations": donationMaps,
        }),
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
      debugPrint(error.toString());
    }
  }

  static Future<List<Donation>> getDonationHistory(
      {required BuildContext context}) async {
    List<Donation> donations = [];
    String token =
        Provider.of<UserProvider>(context, listen: false).user["token"];
    if (token == '') {
      return donations;
    }
    try {
      http.Response response = await http.get(
        Uri.parse("https://serve-surplus.onrender.com/api/donor/history"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Donation History - ${jsonDecode(response.body)}");

      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            final donationHistory = jsonDecode(response.body);
            donations = (donationHistory as List<dynamic>)
                .map((d) => Donation.fromMap(d))
                .toList();
            debugPrint(donations.toString());
          },
        );
      }
    } catch (error) {
      if (context.mounted) {
        debugPrint("Donation History - $error");
      }
    }
    return donations;
  }

  static Future<List<Donation>> getLiveDonations(
      {required BuildContext context}) async {
    List<Donation> donations = [];
    String token =
        Provider.of<UserProvider>(context, listen: false).user["token"];
    if (token == '') {
      return donations;
    }
    try {
      http.Response response = await http.get(
        Uri.parse("https://serve-surplus.onrender.com/api/donor"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("getLiveDonations - ${jsonDecode(response.body)}");
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            final liveDonations = jsonDecode(response.body);
            donations = (liveDonations as List<dynamic>)
                .map((d) => Donation.fromMap(d))
                .toList();
          },
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return donations;
  }

  static Future<List<Order>> getDonorOrders(
      {required BuildContext context, String? status}) async {
    List<Order> orders = [];
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      String getDonorOrdersUrl =
          "https://serve-surplus.onrender.com/api/donor/orders";
      if (status == "Processing" || status == "Delivered") {
        getDonorOrdersUrl += "?status=$status";
      }
      http.Response response = await http.get(
        Uri.parse(
          getDonorOrdersUrl,
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Get Donor Orders - ${jsonDecode(response.body)}");
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            final donorOrders = jsonDecode(response.body);
            orders = (donorOrders as List<dynamic>)
                .map((d) => Order.fromMap(d))
                .toList();
          },
        );
      }
    } catch (error) {
      debugPrint("getDonorOrders - $error");
    }
    return orders;
  }

  static Future<Map<String, dynamic>?> getReceiverDetails({
    required BuildContext context,
    required String receiverId,
  }) async {
    Map<String, dynamic>? result;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      http.Response response = await http.get(
        Uri.parse(
          "https://serve-surplus.onrender.com/api/donor/receiver-info?receiverId=$receiverId",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Get Receiver Details - ${jsonDecode(response.body)}");
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            result = jsonDecode(response.body) as Map<String, dynamic>;
          },
        );
      }
    } catch (error) {
      debugPrint("getReceiverDetails - $error");
    }
    return result;
  }

  static Future<bool> confirmOrder({
    required BuildContext context,
    required String donorId,
    required String receiverId,
    required String orderId,
    required String secret,
  }) async {
    bool isSecretCorrect = false;
    Map<String, dynamic> requestBody = {
      "orderId": orderId,
      "donorId": donorId,
      "receiverId": receiverId,
      "secret": secret
    };
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      http.Response response = await http.post(
        Uri.parse(
          "https://serve-surplus.onrender.com/api/donor/confirm-order",
        ),
        body: jsonEncode(requestBody),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Confirm Order - ${jsonDecode(response.body)}");
      debugPrint("Confirm Order - ${response.statusCode}");

      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            isSecretCorrect = true;
          },
        );
      }
    } catch (error) {
      debugPrint("confirmOrder - $error");
    }
    return isSecretCorrect;
  }
}
