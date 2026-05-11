import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/constants/app_constants.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/network/api_service.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/services/audio_service.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_button.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_checkbox.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_dropdown.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_placeholder.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_textfield.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/error_dialog.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/loading_overlay.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/output_container.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/top_error_snackbar.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final AudioService _audioService = AudioService();

  String _result = "";
  bool _isLoading = false;

  bool _doSummarize = false;
  bool _doTranslate = false;
  bool _doTTS = false;

  bool _audioReady = false;
  bool _isPlaying = false;

  String _summary = "";
  String _translation = "";
  String _final = "";
  String _error = "";
  String _loadingMessage = "";

  String _selectedLanguageName = "Twi";
  String _selectedSpeaker = "male_low";

  String get _translateCode =>
      supportedLanguages[_selectedLanguageName]!["translate"]!;

  String get _ttsCode => supportedLanguages[_selectedLanguageName]!["tts"]!;

  // 🔁 PIPELINE
  void _runPipeline() async {
    if (_controller.text.isEmpty) {
      //validateText not used
      TopErrorNotification.show(context, "Please enter some text");
      return;
    }

    if (!_doSummarize && !_doTranslate && !_doTTS) {
      TopErrorNotification.show(context, "Please select at least one option");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = "";
      _result = "";
      _audioReady = false;
    });

    try {
      final response = await _apiService.pipeline(
        text: _controller.text,
        summarize: _doSummarize,
        translate: _doTranslate,
        targetLanguage: _translateCode,
        tts: _doTTS,
        ttsLanguage: _ttsCode,
        speakerId: _selectedSpeaker,
      );

      setState(() {
        _summary = response["summary"] ?? "";
        _translation = response["translation"] ?? "";
        _final = response["final"] ?? "";
      });

      // Handle audio if returned
      if (_doTTS && response["audio"] != null) {
        await _audioService.loadAudio(response["audio"]);

        setState(() {
          _audioReady = true;
          _isPlaying = false;
        });
      }
    } catch (e) {
      TopErrorNotification.show(
        context,
        "Something went wrong. Please try again.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Assistant")),
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
                    hint: "Enter your text...",
                  ),

                  const SizedBox(height: 16),

                  // OPTIONS
                  CustomCheckbox(
                    title: "Summarize",
                    value: _doSummarize,
                    onChanged: (val) {
                      setState(() => _doSummarize = val!);
                    },
                  ),

                  CustomCheckbox(
                    title: "Translate",
                    value: _doTranslate,
                    onChanged: (val) {
                      setState(() {
                        _doTranslate = val!;
                        if (!_doTranslate) {
                          _doTTS = false; // reset TTS
                        }
                      });
                    },
                  ),

                  CustomCheckbox(
                    title: "Text to Speech",
                    value: _doTTS,
                    onChanged: _doTranslate
                        ? (val) {
                            setState(() => _doTTS = val!);
                          }
                        : null, // disabled when translate is OFF
                  ),

                  const SizedBox(height: 10),

                  // LANGUAGE (if needed)
                  if (_doTranslate)
                    CustomDropdown(
                      label: "Select Language",
                      value: _selectedLanguageName,
                      items: supportedLanguages.keys.toList(),
                      onChanged: (val) =>
                          setState(() => _selectedLanguageName = val!),
                    ),

                  const SizedBox(height: 20),

                  // SPEAKER (only if TTS)
                  if (_doTTS)
                    CustomDropdown(
                      label: "Select Voice",
                      value: _selectedSpeaker,
                      items: speakers,
                      onChanged: (val) =>
                          setState(() => _selectedSpeaker = val!),
                    ),

                  const SizedBox(height: 30),

                  // RUN BUTTON
                  CustomButton(
                    text: "Generate",
                    isLoading: _isLoading,
                    onPressed: _runPipeline,
                  ),

                  const SizedBox(height: 30),

                  // RESULT
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
                  ] else if (_summary.isNotEmpty) ...[
                    const SizedBox(height: 10),
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
                    OutputContainer(result: _summary),
                  ],

                  if (_translation.isNotEmpty) ...[
                    const SizedBox(height: 10),
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
                    OutputContainer(result: _translation),
                  ],

                  const SizedBox(height: 20),

                  // AUDIO CONTROLS
                  if (_audioReady) ...[
                    Text(
                      "Audio Controls",
                      style: GoogleFonts.acme(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () async {
                            if (_isPlaying) {
                              await _audioService.pause();
                              setState(() => _isPlaying = false);
                            } else {
                              setState(() => _isPlaying = true);
                              await _audioService.play();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: () async {
                            await _audioService.pause();
                            await _audioService.seekToStart();

                            setState(() {
                              _isPlaying = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
