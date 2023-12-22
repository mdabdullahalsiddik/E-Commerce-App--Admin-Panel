import 'package:e_shop_admin/Static/all_colors.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  bool? obscureText;
  TextInputAction? textInputAction;
  void Function(String)? onChanged;
  String? hintText;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? Function(String?)? validator;
  TextEditingController? controller;
  CustomTextField({
    super.key,
    this.obscureText,
    this.onChanged,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.controller,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.obscureText ?? false,
      onChanged: widget.onChanged,
      cursorColor: AllColors.primaryColor,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(
            color: AllColors.primaryColor,
            width: 20,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(
            color: AllColors.primaryColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: const BorderSide(
            color: AllColors.primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
