import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import '../models/app_settings.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _chimePlayer = AudioPlayer();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setSharedInstance(true);
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.defaultMode,
    );
    _initialized = true;
  }

  Future<void> playPrompt({
    required String text,
    required AudioMode mode,
    required String chimeAsset,
    required String voiceName,
    required double speechRate,
    required double speechPitch,
  }) async {
    await init();
    switch (mode) {
      case AudioMode.silent:
        break;
      case AudioMode.tone:
        await _playChime(chimeAsset);
        break;
      case AudioMode.voice:
        await _speak(text, voiceName, speechRate, speechPitch);
        break;
      case AudioMode.toneAndVoice:
        await _playChime(chimeAsset);
        await _speak(text, voiceName, speechRate, speechPitch);
        break;
    }
  }

  Future<void> _playChime(String assetKey) async {
    try {
      final assetPath = _chimeAssetPath(assetKey);
      await _chimePlayer.setAsset(assetPath);
      await _chimePlayer.play();
      await _chimePlayer.seek(Duration.zero);
    } catch (e) {
      debugPrint('AudioService chime error: $e');
    }
  }

  Future<void> _speak(
    String text,
    String voiceName,
    double rate,
    double pitch,
  ) async {
    try {
      if (voiceName.isNotEmpty) {
        await _tts.setVoice({'name': voiceName, 'locale': 'en-US'});
      }
      await _tts.setSpeechRate(rate);
      await _tts.setPitch(pitch);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('AudioService TTS error: $e');
    }
  }

  Future<List<dynamic>> getAvailableVoices() async {
    return await _tts.getVoices ?? [];
  }

  Future<void> stopAll() async {
    await _tts.stop();
    await _chimePlayer.stop();
  }

  Future<void> dispose() async {
    await stopAll();
    await _chimePlayer.dispose();
  }

  String _chimeAssetPath(String key) {
    switch (key) {
      case 'bowl':
        return 'assets/audio/tibetan_bowl.mp3';
      case 'tone':
        return 'assets/audio/simple_tone.mp3';
      case 'bell':
      default:
        return 'assets/audio/soft_bell.mp3';
    }
  }
}
