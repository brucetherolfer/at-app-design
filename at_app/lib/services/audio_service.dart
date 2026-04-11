import 'dart:async';
import 'package:audio_session/audio_session.dart';
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
  final AudioPlayer _silentPlayer = AudioPlayer();
  bool _initialized = false;
  bool _silentLoopRunning = false;

  Future<void> init() async {
    if (_initialized) return;

    // Configure audio session once. mixWithOthers allows Spotify/podcasts to
    // keep playing alongside us. duckOthers lowers them while we speak/chime.
    // The AppDelegate also sets this natively — this call keeps the Dart-side
    // audio_session in sync.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers |
          AVAudioSessionCategoryOptions.duckOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
    ));

    // When an interruption (phone call, Siri) ends, the AppDelegate reactivates
    // the native session. Also resume the silent loop here on the Dart side.
    session.interruptionEventStream.listen((event) {
      if (!event.begin && _silentLoopRunning) {
        session.setActive(true).then((_) {
          _silentPlayer.play().catchError((_) {});
        });
      }
    });

    await _tts.setSharedInstance(true);
    await _tts.awaitSpeakCompletion(true);
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.duckOthers,
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
        unawaited(_playChime(chimeAsset));
        await Future.delayed(Duration(milliseconds: _voiceDelayFor(chimeAsset)));
        await _speak(text, voiceName, speechRate, speechPitch);
        break;
    }
  }

  /// Start the near-inaudible background audio loop.
  ///
  /// Plays a 2-second near-silent pink noise file on repeat. This keeps the
  /// AVAudioSession active so iOS doesn't suspend the app between prompts.
  /// Volume is set low (0.05) — barely perceptible, not digital silence.
  Future<void> startSilentLoop() async {
    if (_silentLoopRunning) return;
    try {
      await init();
      final session = await AudioSession.instance;
      await session.setActive(true);
      await _silentPlayer.setAsset('assets/audio/near_silent.m4a');
      await _silentPlayer.setVolume(0.05);
      await _silentPlayer.setLoopMode(LoopMode.one);
      _silentPlayer.play().catchError((Object e) {
        debugPrint('AudioService silent loop error: $e');
        _silentLoopRunning = false;
      });
      _silentLoopRunning = true;
    } catch (e) {
      debugPrint('AudioService startSilentLoop error: $e');
    }
  }

  Future<void> stopSilentLoop() async {
    if (!_silentLoopRunning) return;
    try { await _silentPlayer.stop(); } catch (_) {}
    _silentLoopRunning = false;
  }

  Future<void> _playChime(String assetKey) async {
    try {
      await _chimePlayer.setAsset(_chimeAssetPath(assetKey));
      await _chimePlayer.play();
      await _chimePlayer.seek(Duration.zero);
    } catch (e) {
      debugPrint('AudioService chime error: $e');
    } finally {
      // Re-assert the session after chime — just_audio may release it.
      _reactivateSession();
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
    } finally {
      // flutter_tts calls setActive(false) after each utterance even with
      // setSharedInstance(true). Re-assert immediately so the silent loop
      // keeps the session alive and the Dart isolate stays running.
      _reactivateSession();
    }
  }

  void _reactivateSession() {
    // Delay 500 ms — flutter_tts calls setActive(false) asynchronously
    // after speak() returns. Running immediately loses the race.
    Future.delayed(const Duration(milliseconds: 500), () {
      AudioSession.instance.then((session) {
        session.setActive(true).catchError((Object e) {
          debugPrint('AudioService reactivate error: $e');
          return false;
        });
      });
    });
  }

  Future<List<dynamic>> getAvailableVoices() async {
    return await _tts.getVoices ?? [];
  }

  Future<void> stopAll() async {
    await _tts.stop();
    await _chimePlayer.stop();
    await stopSilentLoop();
  }

  Future<void> dispose() async {
    await stopAll();
    await _chimePlayer.dispose();
    await _silentPlayer.dispose();
  }

  String _chimeAssetPath(String key) {
    switch (key) {
      case 'bowl': return 'assets/audio/tibetan_bowl.m4a';
      case 'tone': return 'assets/audio/simple_tone.m4a';
      case 'bell': default: return 'assets/audio/soft_bell.m4a';
    }
  }

  static const Map<String, int> _chimeVoiceDelayMs = {
    'bell': 800, 'bowl': 1600, 'tone': 400,
  };
  int _voiceDelayFor(String key) => _chimeVoiceDelayMs[key] ?? 800;
}
