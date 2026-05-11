import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multilingual_educational_assitant_mobile_app/features/full_pipeline/presentation/pipeline_screen.dart';
import 'package:multilingual_educational_assitant_mobile_app/features/summarizer/presentation/summarizer_screen.dart';
import 'package:multilingual_educational_assitant_mobile_app/features/text_to_speech/presentation/tts_screen.dart';
import 'package:multilingual_educational_assitant_mobile_app/features/translator/presentation/translation_screen.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/feature_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Assistant"),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "What do you want to do today?",
              style: GoogleFonts.prata(
                textStyle: const TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 50),

            FeatureTile(text: "Summarize Text", screen: SummarizerScreen()),

            const SizedBox(height: 30),

            FeatureTile(text: "Translate Text", screen: TranslationScreen()),

            const SizedBox(height: 30),

            FeatureTile(text: "Text to Speech", screen: TTSScreen()),

            const SizedBox(height: 30),

            FeatureTile(text: "All in One", screen: PipelineScreen()),
          ],
        ),
      ),
    );
  }
}
