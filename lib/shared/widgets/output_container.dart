import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';

class OutputContainer extends StatelessWidget {
  const OutputContainer({super.key, required String result}) : _result = result;

  final String _result;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.only(top: 3, bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.onBackground, width: 0.3),
      ),
      child: SingleChildScrollView(
        child: Text(
          _result,
          style: GoogleFonts.habibi(
            textStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
