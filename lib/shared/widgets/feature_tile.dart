import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';

class FeatureTile extends StatelessWidget {
  final String text;
  // final VoidCallback tap;
  final Widget screen;

  const FeatureTile({super.key, required this.text, required this.screen});

  // void _navigate(BuildContext context, Widget screen) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        title: Text(
          text,
          style: GoogleFonts.acme(textStyle: const TextStyle(fontSize: 15)),
        ),
        trailing: FaIcon(
          FontAwesomeIcons.arrowRight,
          color: AppColors.arrivalBackground,
          size: 15,
        ),
        tileColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.onBackground, width: 0.3),
        ),
      ),
    );
  }
}
