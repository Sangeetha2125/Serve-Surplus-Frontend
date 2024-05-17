import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/providers/location.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/routes/router.dart';
import 'package:serve_surplus/services/user.dart';
import 'package:serve_surplus/views/auth/register.dart';
import 'package:serve_surplus/views/layouts/donor_layout.dart';
import 'package:serve_surplus/views/layouts/receiver_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  void getUserInfo() {
    UserServices.getUserData(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serve Surplus',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Provider.of<UserProvider>(context).user['token'] == ''
          ? const RegisterPage()
          : Provider.of<UserProvider>(context).user['role'] == 'Donor'
              ? const DonorLayout()
              : const ReceiverLayout(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
