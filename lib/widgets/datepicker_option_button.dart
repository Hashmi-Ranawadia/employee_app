import 'package:assignment_employee_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget buildButton(String text, VoidCallback onPressed, String selectedButton,
    String selectedNoDateButton, bool toDate, bool fromDate) {
  bool? isPrimary;
  if (toDate) {
    isPrimary = selectedButton == text;
  } else if (fromDate) {
    isPrimary = selectedNoDateButton == text;
  }
  return Expanded(
    child: InkWell(
      onTap: onPressed,
      child: Container(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color:
                isPrimary! ? AppColors.primaryColor : AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12,
                    color: isPrimary
                        ? AppColors.whiteColor
                        : AppColors.primaryColor))),
      ),
    ),
  );
}
