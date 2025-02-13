import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget buttonTxt;
  final Color bgColor;
  final VoidCallback onTap;

  const CustomButton({super.key, required this.buttonTxt, required this.bgColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: onTap,
        child: buttonTxt
      ),
    );
  }
}
