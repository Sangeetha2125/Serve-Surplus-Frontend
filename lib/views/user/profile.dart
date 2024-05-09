import 'package:flutter/material.dart';
import 'package:serve_surplus/widgets/edit_profile.dart';
import 'package:serve_surplus/widgets/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? token;
  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedToken = preferences.getString("bearer-token");
    if (savedToken == null) return '';
    return savedToken;
  }

  @override
  void initState() {
    getTokenString();
    super.initState();
  }

  void getTokenString() async {
    token = await getToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : token == ''
            ? const EditProfile()
            : const ViewProfile();
  }
}
