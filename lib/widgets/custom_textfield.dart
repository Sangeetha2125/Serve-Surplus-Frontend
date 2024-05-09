import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? readOnlyValue;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final int maxLines;
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnlyValue,
    this.isPassword = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = false;

  @override
  void dispose() {
    super.dispose();
    isVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnlyValue != null,
      initialValue: widget.readOnlyValue,
      obscureText: widget.isPassword && !isVisible,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: TextStyle(
        fontSize: 16,
        color: widget.readOnlyValue != null ? Colors.black45 : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: widget.label,
        labelText: widget.readOnlyValue == null ? null : widget.label,
        hintStyle: const TextStyle(
          color: Colors.black54,
        ),
        contentPadding: const EdgeInsets.all(
          16,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
              )
            : null,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: !isVisible
                    ? const Icon(
                        Icons.visibility,
                      )
                    : const Icon(
                        Icons.visibility_off,
                      ),
              )
            : null,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your ${widget.label}";
        }
        if (widget.isPassword) {
          if (value.length < 6) {
            return "Minimum 6 characters required";
          }
        }
        return null;
      },
    );
  }
}
