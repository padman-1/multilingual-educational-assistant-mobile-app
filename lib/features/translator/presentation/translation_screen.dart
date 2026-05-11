import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/constants/app_constants.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/network/api_service.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/validators.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_button.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_dropdown.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_placeholder.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_textfield.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/output_container.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/top_error_snackbar.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();

  String _result = "";
  bool _isLoading = false;

  String _selectedLanguageName = "Twi";

  String get _translateCode =>
      supportedLanguages[_selectedLanguageName]!["translate"]!;

  // 🔹 TRANSLATE
  void _translate() async {
    //ValidateText used here
    final validationError = validateText(_controller.text);

    if (validationError != null) {
      TopErrorNotification.show(context, validationError);
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      final translated = await _apiService.translate(
        _controller.text,
        _translateCode,
      );

      setState(() {
        _result = translated;
      });
    } catch (e) {
      setState(() {
        TopErrorNotification.show(
          context,
          "Something went wrong. Please try again.",
        );
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Translation")),
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // INPUT
                  CustomTextField(
                    controller: _controller,
                    hint: "Enter text to translate...",
                  ),

                  const SizedBox(height: 16),

                  if (_isLoading) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Translating...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),

                    const LoadingPlaceholder(),
                  ] else if (_result.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      "Translated Text",
                      style: GoogleFonts.acme(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OutputContainer(result: _result),
                  ],
                  const SizedBox(height: 20),

                  // LANGUAGE DROPDOWN
                  CustomDropdown(
                    label: "Select Language",
                    value: _selectedLanguageName,
                    items: supportedLanguages.keys.toList(),
                    onChanged: (val) =>
                        setState(() => _selectedLanguageName = val!),
                  ),

                  const SizedBox(height: 50),

                  // TRANSLATE BUTTON
                  CustomButton(
                    text: "Translate",
                    isLoading: _isLoading,
                    onPressed: _translate,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
