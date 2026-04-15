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
  final AudioPlayer _voiceFilePlayer = AudioPlayer();
  final AudioPlayer _silentPlayer = AudioPlayer();
  bool _initialized = false;
  bool _silentLoopRunning = false;

  // Pre-recorded voice files keyed by prompt UID.
  // When a match exists, the file plays via just_audio instead of TTS —
  // same lock-screen path as the chime, no Siri required.
  static const Map<String, String> _voiceAssets = {
    'fms_dir_001': 'assets/audio/fms_directions.m4a',
    'fms_seq_001': 'assets/audio/fms_seq_001.m4a',
    'fms_seq_002': 'assets/audio/fms_seq_002.m4a',
    'fms_seq_003': 'assets/audio/fms_seq_003.m4a',
    'fms_seq_004': 'assets/audio/fms_seq_004.m4a',
  };

  String? _voiceAsset(String? uid) => uid == null ? null : _voiceAssets[uid];

  Future<void> init() async {
    if (_initialized) return;

    // mixWithOthers only — no duckOthers here. Ducking is scoped to each
    // prompt delivery via _duckForPrompt()/_restoreMix(). Permanent duckOthers
    // would suppress Spotify/music the entire session because the silent
    // keepalive loop counts as active audio to iOS.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
    ));

    // When an interruption (phone call, Siri) ends, re-activate and resume loop.
    session.interruptionEventStream.listen((event) {
      if (!event.begin && _silentLoopRunning) {
        session.setActive(true).then((_) {
          _silentPlayer.play().catchError((_) {});
        });
      }
    });

    await _tts.setSharedInstance(true);
    await _tts.awaitSpeakCompletion(true); // speak() blocks until speech finishes
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        // No duckOthers here — ducking is managed by _duckForPrompt()
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
    String? promptUid,
  }) async {
    await init();
    final voiceFile = _voiceAsset(promptUid);
    switch (mode) {
      case AudioMode.silent:
        break;
      case AudioMode.tone:
        await _duckForPrompt();
        try {
          await _playChime(chimeAsset);
        } finally {
          await _restoreMix();
        }
        break;
      case AudioMode.voice:
        await _duckForPrompt();
        try {
          if (voiceFile != null) {
            await _playVoiceFile(voiceFile);
          } else {
            await _speak(text, voiceName, speechRate, speechPitch);
          }
        } finally {
          await _restoreMix();
        }
        break;
      case AudioMode.toneAndVoice:
        await _duckForPrompt();
        try {
          unawaited(_playChime(chimeAsset));
          await Future.delayed(Duration(milliseconds: _voiceDelayFor(chimeAsset)));
          if (voiceFile != null) {
            await _playVoiceFile(voiceFile);
          } else {
            await _speak(text, voiceName, speechRate, speechPitch);
          }
        } finally {
          await _restoreMix();
        }
        break;
    }
  }

  /// Switch to duckOthers before prompt delivery so music lowers during
  /// chime + voice. Stops the silent loop first — reconfiguring the session
  /// while just_audio is playing triggers an interruption event that can
  /// leave the player in a broken state. The native Swift keepalive keeps
  /// AVAudioSession alive while the loop is paused.
  Future<void> _duckForPrompt() async {
    try {
      // Stop the Dart silent loop before session reconfigure.
      await _silentPlayer.stop();
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers |
            AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
      ));
      await session.setActive(true);
    } catch (e) {
      debugPrint('AudioService duck error: $e');
    }
  }

  /// Restore mixWithOthers after prompt delivery so music returns to full
  /// volume. Fully reinitialises the silent loop (setAsset + setVolume +
  /// setLoopMode + play) — a reconfigure interrupts just_audio's internal
  /// player state, so calling play() alone on the interrupted player is not
  /// enough; the asset must be re-set.
  Future<void> _restoreMix() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
      ));
      await session.setActive(true);
      // Full reinit of the silent loop after session reconfigure.
      if (_silentLoopRunning) {
        try {
          await _silentPlayer.setAsset('assets/audio/near_silent.m4a');
          await _silentPlayer.setVolume(0.05);
          await _silentPlayer.setLoopMode(LoopMode.one);
        } catch (_) {}
        _silentPlayer.play().catchError((Object e) {
          debugPrint('AudioService silent loop resume error: $e');
          _silentLoopRunning = false;
        });
      }
    } catch (e) {
      debugPrint('AudioService restore mix error: $e');
    }
  }

  Future<void> _playVoiceFile(String assetPath) async {
    try {
      await _voiceFilePlayer.setAsset(assetPath);
      await _voiceFilePlayer.play();
      await _voiceFilePlayer.seek(Duration.zero);
    } catch (e) {
      debugPrint('AudioService voice file error: $e');
    } finally {
      _reactivateSession();
    }
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
      // flutter_tts calls setActive(false) asynchronously after speak()
      // returns even with setSharedInstance(true). Reactivate 500ms later
      // to counteract it before _restoreMix() also reasserts the session.
      _reactivateSession();
    }
  }

  void _reactivateSession() {
    // Delay 500ms — flutter_tts deactivates the session asynchronously
    // after speak() returns, losing a synchronous call here.
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

  /// Start a near-inaudible audio loop to keep AVAudioSession active.
  /// iOS only suspends background apps when there is no active audio session.
  Future<void> startSilentLoop() async {
    if (_silentLoopRunning) return;
    try {
      await init();
      final session = await AudioSession.instance;
      await session.setActive(true);
      await _silentPlayer.setAsset('assets/audio/near_silent.m4a');
      await _silentPlayer.setVolume(0.05);
      await _silentPlayer.setLoopMode(LoopMode.one);
      // Not awaited — play() for LoopMode.one never completes (infinite loop).
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

  Future<void> stopAll() async {
    await _tts.stop();
    await _chimePlayer.stop();
    await _voiceFilePlayer.stop();
    await stopSilentLoop();
  }

  Future<void> dispose() async {
    await stopAll();
    await _chimePlayer.dispose();
    await _voiceFilePlayer.dispose();
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
