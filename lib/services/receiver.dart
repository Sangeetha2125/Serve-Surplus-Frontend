import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/constants/http_response_handler.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/schema/donation.dart';
import "package:http/http.dart" as http;
import 'package:serve_surplus/schema/order.dart';

class ReceiverServices {
  static Future<List<Donation>> getAllNearestDonations(
      {required BuildContext context}) async {
    List<Donation> donations = [];
    String token =
        Provider.of<UserProvider>(context, listen: false).user["token"];
    if (token == '') return donations;
    try {
      http.Response response = await http.get(
        Uri.parse("https://serve-surplus.onrender.com/api/receiver"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Get All Nearest Donations: ${jsonDecode(response.body)}");
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            List<dynamic> responseBody = jsonDecode(response.body);
            debugPrint(responseBody.toString());
            for (int i = 0; i < responseBody.length; i++) {
              final item = responseBody[i];
              Map<String, dynamic> donationItem = {
                "donor": item["donor"],
                "distance": item["distance"],
                "food": '',
                "quantity": 0,
                "donatedAt": null,
                "image": '',
                "donationId": null,
              };
              for (int j = 0; j < (item["donations"] as List).length; j++) {
                donationItem["food"] = item["donations"][j]["food"];
                donationItem["image"] = item["donations"][j]["image"];
                donationItem["quantity"] = item["donations"][j]["quantity"];
                donationItem["donatedAt"] = item["donations"][j]["donatedAt"];
                donationItem["donationId"] = item["donations"][j]["_id"];
                donations.add(Donation.fromMap(donationItem));
                debugPrint(
                    "Donation: ${Donation.fromMap(donationItem).toJson()}");
              }
              debugPrint("All Nearest Donations: $donations");
            }
          },
        );
      }
    } catch (error) {
      if (context.mounted) {
        debugPrint("View Nearest Donations - $error");
      }
    }
    return donations;
  }

  static Future<Map<String, dynamic>?> getDonorDetails(
      {required BuildContext context,
      required String donorId,
      bool isDonorReference = false}) async {
    Map<String, dynamic>? result;
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      String getDonorDetailsUrl =
          "https://serve-surplus.onrender.com/api/receiver/donor-info?donorId=$donorId";
      if (isDonorReference) {
        getDonorDetailsUrl += "&isDonorReference=$isDonorReference";
      }
      http.Response response = await http.get(
        Uri.parse(
          getDonorDetailsUrl,
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Get Donor Details - ${jsonDecode(response.body)}");
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
      debugPrint("getDonorDetails - $error");
    }
    return result;
  }

  static Future<List<Order>> getReceiverOrders(
      {required BuildContext context, String? status}) async {
    List<Order> orders = [];
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      String getReceiverOrdersUrl =
          "https://serve-surplus.onrender.com/api/receiver/orders";
      if (status == "Processing" || status == "Delivered") {
        getReceiverOrdersUrl += "?status=$status";
      }
      http.Response response = await http.get(
        Uri.parse(
          getReceiverOrdersUrl,
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint("Get Receiver Orders - ${jsonDecode(response.body)}");
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            final receiverOrders = jsonDecode(response.body);
            orders = (receiverOrders as List<dynamic>)
                .map((d) => Order.fromMap(d))
                .toList();
          },
        );
      }
    } catch (error) {
      debugPrint("getReceiverOrders - $error");
    }
    return orders;
  }

  static void orderFood({
    required BuildContext context,
    required String donorId,
    required Donation donation,
  }) async {
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      http.Response response = await http.post(
        Uri.parse("https://serve-surplus.onrender.com/api/receiver/$donorId"),
        body: donation.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      debugPrint(donation.toJson());
      debugPrint(jsonDecode(response.body).toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
