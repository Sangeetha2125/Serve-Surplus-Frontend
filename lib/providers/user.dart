import 'dart:convert';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _user = {
    "email": '',
    "token": '',
    "role": '',
  };

  Map<String, dynamic> get user => _user;

  void setUser(String user) {
    _user = jsonDecode(user);
    notifyListeners();
  }

  void removeUser() {
    _user = {
      "email": '',
      "token": '',
      "role": '',
    };
    notifyListeners();
  }
}
