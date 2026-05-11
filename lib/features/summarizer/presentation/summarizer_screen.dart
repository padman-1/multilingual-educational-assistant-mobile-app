import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/network/api_service.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/validators.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_button.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_placeholder.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_textfield.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/output_container.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/top_error_snackbar.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();

  String _result = "";
  bool _isLoading = false;

  void _summarize() async {
    //ValidateText used here
    final validationError = validateText(_controller.text);

    if (validationError != null) {
      TopErrorNotification.show(context, validationError);
      // showErrorDialog(context, validationError);
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      final summary = await _apiService.summarize(_controller.text);

      setState(() {
        _result = summary;
      });
    } catch (e) {
      setState(() {
        TopErrorNotification.show(
          context,
          "Something went wrong. Please try again.",
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Summarizer")),
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
                  CustomTextField(
                    controller: _controller,
                    hint: "Enter text to summarize...",
                  ),

                  const SizedBox(height: 50),

                  if (_isLoading) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "summarizing...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),

                    const LoadingPlaceholder(),
                  ] else if (_result.isNotEmpty) ...[
                    Text(
                      "Summarized Text",
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
                  const SizedBox(height: 50),

                  CustomButton(
                    text: "Summarize",
                    isLoading: _isLoading,
                    onPressed: _summarize,
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
