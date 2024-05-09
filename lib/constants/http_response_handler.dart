import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;

void httpResponseHandler({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
    case 201:
      onSuccess();
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            jsonDecode(response.body)["message"].toString(),
          ),
        ),
      );
  }
}
