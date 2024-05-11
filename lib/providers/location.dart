import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? location;
  void setLocation(Position? geoLocation) {
    location = geoLocation;
    notifyListeners();
  }
}
