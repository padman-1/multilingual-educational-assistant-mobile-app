import 'dart:convert';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  bool _isLoaded = false;

  Future<void> loadAudio(Uint8List bytes) async {
    final uri = Uri.parse("data:audio/wav;base64,${base64Encode(bytes)}");

    await _player.setAudioSource(AudioSource.uri(uri));
    _isLoaded = true;
  }

  Future<void> play() async {
    if (_isLoaded) {
      final duration = _player.duration;
      final position = _player.position;

      // If audio finished, reset to start
      if (duration != null && position >= duration) {
        await _player.seek(Duration.zero);
      }

      await _player.play();
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
    _isLoaded = false;
  }

  Future<void> seekToStart() async {
    await _player.seek(Duration.zero);
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  void dispose() {
    _player.dispose();
  }
}
