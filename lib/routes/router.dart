import 'package:flutter/material.dart';
import 'package:serve_surplus/schema/donation.dart';
import 'package:serve_surplus/schema/order.dart';
import 'package:serve_surplus/views/auth/login.dart';
import 'package:serve_surplus/views/donor/add_donation.dart';
import 'package:serve_surplus/views/donor/donation_history.dart';
import 'package:serve_surplus/views/donor/individual_order.dart';
import 'package:serve_surplus/views/layouts/donor_layout.dart';
import 'package:serve_surplus/views/layouts/receiver_layout.dart';
import 'package:serve_surplus/views/receiver/individual_donation.dart';
import 'package:serve_surplus/views/receiver/individual_order.dart';
import 'package:serve_surplus/views/user/profile.dart';
import 'package:serve_surplus/views/auth/register.dart';
import 'package:serve_surplus/widgets/edit_profile.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case RegisterPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const RegisterPage(),
      );
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const LoginPage(),
      );
    case ProfilePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ProfilePage(),
      );
    case EditProfile.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const EditProfile(),
      );
    case DonorLayout.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const DonorLayout(),
      );
    case AddDonationPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => AddDonationPage(
          items: routeSettings.arguments as int,
        ),
      );
    case DonationHistoryPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const DonationHistoryPage(),
      );
    case IndividualDonationPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => IndividualDonationPage(
          donorId: (routeSettings.arguments as Map<String, dynamic>)["donorId"]
              as String,
          donationId: (routeSettings.arguments
              as Map<String, dynamic>)["donationId"]! as String,
          donation: (routeSettings.arguments
              as Map<String, dynamic>)["donation"] as Donation,
        ),
      );
    case IndividualDonorOrderPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => IndividualDonorOrderPage(
          order: (routeSettings.arguments as Order),
        ),
      );
    case ReceiverLayout.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ReceiverLayout(),
      );
    case IndividualReceiverOrderPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => IndividualReceiverOrderPage(
          order: (routeSettings.arguments as Order),
        ),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("Route doesn't exist"),
          ),
        ),
      );
  }
}
