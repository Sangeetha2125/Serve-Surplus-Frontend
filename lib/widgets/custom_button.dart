import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final GlobalKey<FormState>? formKey;
  final VoidCallback userService;
  const CustomButton(this.text,
      {super.key, required this.formKey, required this.userService});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.formKey != null) {
          if (widget.formKey!.currentState!.validate()) {
            widget.userService();
          }
        } else {
          widget.userService();
        }
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
