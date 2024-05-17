import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/services/user.dart';
import 'package:serve_surplus/views/auth/login.dart';
import 'package:serve_surplus/widgets/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Map<String, dynamic>? user;

  getProfile() async {
    user = await UserServices.getProfile(context: context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

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
          IconButton(
            onPressed: () async {
              Provider.of<UserProvider>(context, listen: false).removeUser();
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove("bearer-token");
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginPage.routeName, (route) => false);
              }
            },
            icon: const Icon(
              Icons.logout,
              size: 20,
            ),
            tooltip: "Logout",
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16).copyWith(
                top: 30,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      "assets/images/user.png",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "${user!["name"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    color: const Color.fromARGB(44, 153, 155, 156),
                    child: Column(
                      children: [
                         Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Email Address: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1.75,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${user!["email"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Phone Number: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${user!["phone"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Address: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1.75,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${user!["doorNumber"]}, ${user!["street"]}, ${user!["area"]}, ${user!["city"]} - ${user!["pincode"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        EditProfile.routeName,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(
                        42,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
