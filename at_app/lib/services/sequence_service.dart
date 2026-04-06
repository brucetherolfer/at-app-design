import 'dart:async';
import '../models/sequence.dart';
import '../models/app_settings.dart';
import '../repositories/prompt_repository.dart';
import '../repositories/sequence_repository.dart';
import '../repositories/settings_repository.dart';
import 'notification_service.dart';
import 'audio_service.dart';

class SequenceService {
  static final SequenceService _instance = SequenceService._internal();
  factory SequenceService() => _instance;
  SequenceService._internal();

  Timer? _timer;
  bool _isRunning = false;
  bool get isRunning => _isRunning;

  final _promptRepo = PromptRepository();
  final _seqRepo = SequenceRepository();
  final _settingsRepo = SettingsRepository();

  Future<void> fireSequence() async {
    if (_isRunning) return;
    _isRunning = true;

    final settings = await _settingsRepo.load();
    final seqUid = settings.activeSequenceUid;
    if (seqUid == null) { _isRunning = false; return; }

    final seq = await _seqRepo.getByUid(seqUid);
    if (seq == null || seq.promptUids.isEmpty) { _isRunning = false; return; }

    await _playSequence(seq, settings);
    _isRunning = false;
  }

  Future<void> _playSequence(Sequence seq, AppSettings settings) async {
    for (int i = 0; i < seq.promptUids.length; i++) {
      final promptUid = seq.promptUids[i];
      // Find prompt by uid — search built-in libraries
      final allLibPrompts = await _promptRepo.getByLibrary('builtin_all');
      final allPrompts = [
        ...allLibPrompts,
        ...await _promptRepo.getByLibrary('builtin_bruces'),
        ...await _promptRepo.getByLibrary('builtin_mio'),
      ];
      final prompt = allPrompts.firstWhere(
        (p) => p.uid == promptUid,
        orElse: () => allPrompts.first,
      );

      await NotificationService.showPrompt(prompt.text);
      await AudioService().playPrompt(
        text: prompt.text,
        mode: settings.audioMode,
        chimeAsset: settings.selectedChime,
        voiceName: settings.selectedVoiceName,
        speechRate: settings.speechRate,
        speechPitch: settings.speechPitch,
      );

      if (i < seq.promptUids.length - 1) {
        await Future.delayed(Duration(seconds: seq.gapSeconds));
      }
    }
  }

  void cancel() {
    _timer?.cancel();
    _isRunning = false;
  }
}
