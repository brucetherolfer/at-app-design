import 'dart:async';
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
        // Chime starts immediately (non-blocking), voice enters after decay delay
        unawaited(_playChime(chimeAsset));
        await Future.delayed(Duration(milliseconds: _voiceDelayFor(chimeAsset)));
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
        return 'assets/audio/tibetan_bowl.m4a';
      case 'tone':
        return 'assets/audio/simple_tone.m4a';
      case 'bell':
      default:
        return 'assets/audio/soft_bell.m4a';
    }
  }

  /// How long to wait after the chime starts before the voice begins.
  /// Tune these once you hear the actual sounds — just change the ms values.
  static const Map<String, int> _chimeVoiceDelayMs = {
    'bell':  800,   // medium decay — voice enters as bell fades
    'bowl':  1600,  // long sustain — let it bloom before speaking
    'tone':  400,   // short/punchy — voice enters quickly
  };

  int _voiceDelayFor(String key) => _chimeVoiceDelayMs[key] ?? 800;
}
