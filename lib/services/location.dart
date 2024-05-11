import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/constants/http_response_handler.dart';
import 'package:serve_surplus/providers/location.dart';
import "package:http/http.dart" as http;
import 'package:serve_surplus/providers/user.dart';

class LocationServices {
  static void setUserLocation(BuildContext context) async {
    Position? location =
        Provider.of<LocationProvider>(context, listen: false).location;
    if (location == null) return;
    double? latitude = location.latitude;
    double? longitude = location.longitude;
    Map<String, double?> locationCoordinates = {
      "latitude": latitude,
      "longitude": longitude,
    };
    debugPrint(locationCoordinates.toString());
    try {
      String token =
          Provider.of<UserProvider>(context, listen: false).user["token"];
      http.Response response = await http.post(
        Uri.parse(
            "https://serve-surplus.onrender.com/api/profile/update-location"),
        body: jsonEncode(locationCoordinates),
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
            debugPrint("Success");
          },
        );
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
