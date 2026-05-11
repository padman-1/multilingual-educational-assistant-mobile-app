import 'package:flutter/material.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.arrivalBackground),
        ),
      ),
    );
  }
}
