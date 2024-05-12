import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? readOnlyValue;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final int maxLines;
  final bool extraWidth;
  final bool isOrderModule;
  final int orderQuantity;
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnlyValue,
    this.isPassword = false,
    this.maxLines = 1,
    this.extraWidth = false,
    this.isOrderModule = false,
    this.orderQuantity = 0,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = false;

  @override
  void dispose() {
    isVisible = false;
    super.dispose();
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
        contentPadding: widget.extraWidth
            ? const EdgeInsets.all(16).copyWith(right: 24)
            : const EdgeInsets.all(16),
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
        if (widget.extraWidth) {
          if (value == null || value.isEmpty) {
            if (widget.isOrderModule) {
              return "Enter the no. of items you wish to request";
            } else {
              return "Enter the no. of items you wish to donate";
            }
          }
          if (int.parse(value) <= 0) {
            if (widget.isOrderModule) {
              return "Items should be greater than 0";
            } else {
              return "Items should be greater than 0";
            }
          }
          if (widget.isOrderModule && int.parse(value) > widget.orderQuantity) {
            return "Items can't be greater than available quantity";
          }
        }
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
