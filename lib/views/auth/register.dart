import 'package:flutter/material.dart';
import 'package:serve_surplus/services/auth.dart';
import 'package:serve_surplus/widgets/custom_button.dart';
import 'package:serve_surplus/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = "/register";
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedRole = "Donor";

  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void registerUser() {
    AuthServices.registerUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _registerKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Create an account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      label: "Email Address",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      isPassword: true,
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        contentPadding: EdgeInsets.all(
                          16,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Donor",
                          child: Text("Donor"),
                        ),
                        DropdownMenuItem(
                          value: "Receiver",
                          child: Text("Receiver"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      "Register",
                      formKey: _registerKey,
                      userService: registerUser,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: const Text(
                            "Login Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
