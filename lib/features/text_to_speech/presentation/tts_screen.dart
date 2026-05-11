import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/constants/app_constants.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/network/api_service.dart';
import 'package:multilingual_educational_assitant_mobile_app/core/services/audio_service.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/colors.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/validators.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_button.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_dropdown.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/custom_textfield.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/widgets/top_error_snackbar.dart';

class TTSScreen extends StatefulWidget {
  const TTSScreen({super.key});

  @override
  State<TTSScreen> createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final AudioService _audioService = AudioService();

  bool _isLoading = false;
  bool _audioReady = false;
  bool _isPlaying = false;

  String _selectedLanguageName = "Twi";
  String _selectedSpeaker = "male_low";

  String get _ttsCode => supportedLanguages[_selectedLanguageName]!["tts"]!;

  // 🔊 LOAD AUDIO
  void _loadAudio() async {
    //ValidateText used here
    final validationError = validateText(_controller.text);

    if (validationError != null) {
      TopErrorNotification.show(context, validationError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final audioBytes = await _apiService.tts(
        _controller.text,
        _ttsCode,
        _selectedSpeaker,
      );

      await _audioService.loadAudio(audioBytes);

      setState(() {
        _audioReady = true;
        _isPlaying = false;
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
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Text to Speech")),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // INPUT
                CustomTextField(
                  controller: _controller,
                  hint: "Enter text to convert to speech...",
                ),

                const SizedBox(height: 50),

                // LANGUAGE
                CustomDropdown(
                  label: "Select Language",
                  value: _selectedLanguageName,
                  items: supportedLanguages.keys.toList(),
                  onChanged: (val) =>
                      setState(() => _selectedLanguageName = val!),
                ),

                const SizedBox(height: 30),

                // SPEAKER
                CustomDropdown(
                  label: "Select Speaker",
                  value: _selectedSpeaker,
                  items: speakers,
                  onChanged: (val) => setState(() => _selectedSpeaker = val!),
                ),

                const SizedBox(height: 30),

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
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: devSize.width / 2,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.onBackground,
                        width: 0.3,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.arrivalBackground,
                            size: 34,
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
                        SizedBox(width: 15),
                        IconButton(
                          icon: const Icon(
                            Icons.stop,
                            color: AppColors.arrivalBackground,
                            size: 30,
                          ),
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
                  ),
                ],

                const SizedBox(height: 30),

                // LISTEN BUTTON
                CustomButton(
                  text: "Generate Audio",
                  isLoading: _isLoading,
                  onPressed: _loadAudio,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
