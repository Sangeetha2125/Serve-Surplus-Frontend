import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/views/auth/login.dart';
import 'package:serve_surplus/widgets/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "My Account",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            position: PopupMenuPosition.under,
            onSelected: (int value) async {
              if (value == 1) {
                Navigator.pushNamed(
                  context,
                  EditProfile.routeName,
                );
              } else if (value == 2) {
                Provider.of<UserProvider>(context, listen: false).removeUser();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.remove("bearer-token");
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.routeName, (route) => false);
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Text("Edit Profile"),
              ),
              const PopupMenuItem(
                value: 2,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Text("Logout"),
              )
            ],
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
