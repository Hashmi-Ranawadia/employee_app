import 'package:assignment_employee_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final Icon? suffixIcon;
  String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      readOnly: readOnly,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        hintText: "${hintText}",
        hintStyle: TextStyle(color: AppColors.greyColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColors.greyColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColors.greyColor),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon
      ),
      validator: validator,
    );
  }
}
