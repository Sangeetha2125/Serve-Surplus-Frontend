import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'package:serve_surplus/constants/http_response_handler.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/views/layouts/donor_layout.dart';
import 'package:serve_surplus/views/layouts/receiver_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  static void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("bearer-token");
      if (token == null) {
        return;
      }

      http.Response response = await http.get(
          Uri.parse("https://serve-surplus.onrender.com/api/auth"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer $token"
          });
      if (response.statusCode == 200) {
        await preferences.setString(
            "bearer-token", jsonDecode(response.body)['token']);
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static void createProfile(
      {required BuildContext context,
      required String name,
      required String phone,
      required String doorNumber,
      required String street,
      required String area,
      required String city,
      required String pincode}) async {
    try {
      Map<String, dynamic> user =
          Provider.of<UserProvider>(context, listen: false).user;
      String email = user["email"];
      String role = user["role"];
      String token = user["token"];
      Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "role": role,
        "phone": phone,
        "doorNumber": doorNumber,
        "street": street,
        "area": area,
        "city": city,
        "pincode": pincode,
      };
      SharedPreferences preferences = await SharedPreferences.getInstance();
      http.Response response = await http.post(
          Uri.parse("https://serve-surplus.onrender.com/api/profile/create"),
          body: jsonEncode(requestBody),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer $token"
          });

      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () async {
            await preferences.setString("bearer-token", token);
            if (context.mounted) {
              if (role == "Donor") {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  DonorLayout.routeName,
                  (route) => false,
                );
              } else if (role == "Receiver") {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ReceiverLayout.routeName,
                  (route) => false,
                );
              }
            }
          },
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static Future<Map<String, dynamic>> getProfile(
      {required BuildContext context}) async {
    Map<String, dynamic> user = {};
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("bearer-token");
      if (token == null) {
        return user;
      }
      http.Response response = await http.get(
        Uri.parse("https://serve-surplus.onrender.com/api/profile"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () {
            user = jsonDecode(response.body) as Map<String, dynamic>;
          },
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return user;
  }
}
