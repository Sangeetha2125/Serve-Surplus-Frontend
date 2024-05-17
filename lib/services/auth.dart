import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'package:serve_surplus/constants/http_response_handler.dart';
import 'package:serve_surplus/models/user.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/views/layouts/donor_layout.dart';
import 'package:serve_surplus/views/layouts/receiver_layout.dart';
import 'package:serve_surplus/views/user/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static void registerUser({
    required BuildContext context,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        password: password,
        token: '',
        role: role,
      );

      http.Response response = await http.post(
        Uri.parse("https://serve-surplus.onrender.com/api/auth/register"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      if (context.mounted) {
        httpResponseHandler(
          context: context,
          response: response,
          onSuccess: () async {
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(response.body);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Your account has been created successfully"),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                ProfilePage.routeName,
                (route) => false,
              );
            }
          },
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static void loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      User user =
          User(id: '', email: email, password: password, token: '', role: '');

      http.Response response = await http.post(
          Uri.parse("https://serve-surplus.onrender.com/api/auth/login"),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      debugPrint("error: ${jsonDecode(response.body)}");
      if (context.mounted) {
        httpResponseHandler(
            context: context,
            response: response,
            onSuccess: () async {
              if (context.mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .setUser(jsonEncode(jsonDecode(response.body)["user"]));
                if (jsonDecode(response.body)["profileCreated"] != true) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ProfilePage.routeName,
                    (route) => false,
                  );
                } else {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.setString("bearer-token",
                      jsonDecode(response.body)["user"]["token"]);
                  if (context.mounted) {
                    String role = jsonDecode(response.body)["user"]["role"];
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
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Logged in successfully"),
                    ),
                  );
                }
              }
            });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
