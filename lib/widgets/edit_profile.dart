import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serve_surplus/providers/user.dart';
import 'package:serve_surplus/services/user.dart';
import 'package:serve_surplus/widgets/custom_button.dart';
import 'package:serve_surplus/widgets/custom_textfield.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = "/edit-profile";
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _editProfileKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _doorNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  void editProfile() {
    UserServices.createProfile(
      context: context,
      name: _nameController.text,
      phone: _phoneController.text,
      doorNumber: _doorNumberController.text,
      street: _streetController.text,
      area: _areaController.text,
      city: _cityController.text,
      pincode: _pinCodeController.text,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _doorNumberController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _editProfileKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: "Name",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  readOnlyValue:
                      Provider.of<UserProvider>(context).user["email"],
                  label: "Email",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  label: "Mobile Number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _doorNumberController,
                  label: "Door Number",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _streetController,
                  label: "Street",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _areaController,
                  label: "Area",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _cityController,
                  label: "City",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _pinCodeController,
                  label: "Pin Code",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  "Save Profile",
                  formKey: _editProfileKey,
                  userService: editProfile,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
