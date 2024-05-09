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

class AuthService {
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                ProfilePage.routeName,
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Your account has been created successfully"),
                ),
              );
            }
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

  static void loginUser({
    required BuildContext context,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      User user =
          User(id: '', email: email, password: password, token: '', role: role);

      http.Response response = await http.post(
          Uri.parse("https://serve-surplus.onrender.com/api/auth/login"),
          body: user.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

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
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

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
          Uri.parse("https://serve-surplus.onrender.com/api/auth/"),
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
      if (context.mounted) {
        debugPrint(error.toString());
      }
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
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
