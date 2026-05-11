import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool?)? onChanged;

  const CustomCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: AppColors.warmUpBackground,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text(
        title,
        style: GoogleFonts.prata(
          textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ), // fonts to try out : supermercadoOne, habibi, prata,
      ),
      value: value,
      onChanged: onChanged,
      // controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
