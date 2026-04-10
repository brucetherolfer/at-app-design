import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'repositories/blackout_repository.dart';
import 'repositories/isar_service.dart';
import 'repositories/seed_data.dart';
import 'repositories/settings_repository.dart';
import 'repositories/library_repository.dart';
import 'repositories/prompt_repository.dart';
import 'repositories/sequence_repository.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.open();
  await _seedIfNeeded();
  await _seedBlackoutsIfNeeded();
  await _migrateLibraries();
  await _migrateFmsPrompts();
  await _resetRunState();
  await NotificationService.init();

  runApp(const ProviderScope(child: AtApp()));
}

Future<void> _resetRunState() async {
  final settings = await SettingsRepository().load();
  if (settings.isRunning || settings.isPaused) {
    settings
      ..isRunning = false
      ..isPaused = false;
    await SettingsRepository().save(settings);
  }
}

Future<void> _seedIfNeeded() async {
  final libRepo = LibraryRepository();
  final libs = await libRepo.getAll();
  if (libs.isNotEmpty) return;

  // Seed all built-in libraries
  await libRepo.save(allPromptsLibrary);
  await libRepo.save(brucesLibrary);
  await libRepo.save(mioLibrary);
  await libRepo.save(fmsDirectionsLibrary);
  await libRepo.save(fmsSequenceLibrary);
  await libRepo.save(modifiedClassicLibrary);
  await libRepo.save(bodyscanFullLibrary);
  await libRepo.save(bodyscanJointsAnatLibrary);
  await libRepo.save(bodyscanJointsPlainLibrary);
  await libRepo.save(questionsLibrary);

  // Seed all built-in prompts
  final promptRepo = PromptRepository();
  await promptRepo.saveAll(allPrompts);
  await promptRepo.saveAll(brucesPrompts);
  await promptRepo.saveAll(mioPrompts);
  await promptRepo.saveAll(fmsDirectionsPrompts);
  await promptRepo.saveAll(fmsSequencePrompts);
  await promptRepo.saveAll(modifiedClassicPrompts);
  await promptRepo.saveAll(bodyscanFullPrompts);
  await promptRepo.saveAll(bodyscanJointsAnatPrompts);
  await promptRepo.saveAll(bodyscanJointsPlainPrompts);
  await promptRepo.saveAll(questionsPrompts);

  // Seed built-in sequences
  final seqRepo = SequenceRepository();
  await seqRepo.save(primaryControlSequence);
  await seqRepo.save(bodyscanFullSequence);
  await seqRepo.save(bodyscanJointsAnatSequence);
  await seqRepo.save(bodyscanJointsPlainSequence);

  // Load settings to trigger default creation
  await SettingsRepository().load();
}

/// Seeds the default Sleep blackout window on first launch.
/// Runs on every launch but only writes if the window doesn't exist yet.
Future<void> _seedBlackoutsIfNeeded() async {
  final repo = BlackoutRepository();
  final existing = await repo.getAll();
  final hasSleep = existing.any((w) => w.uid == 'builtin_blackout_sleep');
  if (!hasSleep) {
    await repo.save(sleepBlackoutWindow);
  }
}

/// Adds new built-in libraries to existing installs.
/// The main seed guard (if libs.isNotEmpty) blocks new libraries from being
/// added to phones that already had libraries seeded. This migration runs
/// independently on every launch but only writes what's missing.
Future<void> _migrateLibraries() async {
  final libRepo = LibraryRepository();
  final promptRepo = PromptRepository();
  final existing = (await libRepo.getAll()).map((l) => l.uid).toSet();

  if (!existing.contains('builtin_fms_directions')) {
    await libRepo.save(fmsDirectionsLibrary);
    await promptRepo.saveAll(fmsDirectionsPrompts);
  }

  if (!existing.contains('builtin_fms_sequence')) {
    await libRepo.save(fmsSequenceLibrary);
    await promptRepo.saveAll(fmsSequencePrompts);
  }

  if (!existing.contains('builtin_questions')) {
    await libRepo.save(questionsLibrary);
    await promptRepo.saveAll(questionsPrompts);
  }
}

/// Updates FM's prompt texts in existing installs to the canonical wording.
/// Safe to run on every launch — only writes when text differs.
Future<void> _migrateFmsPrompts() async {
  final repo = PromptRepository();
  final migrations = {
    'fms_dir_001':
        'Let your neck be free. So your head can go forward and up. The back can lengthen and widen and your knees go forward and away.',
    'fms_seq_001': 'Let your neck be free.',
    'fms_seq_002': 'So your head can go forward and up.',
    'fms_seq_003': 'The back can lengthen and widen.',
    'fms_seq_004': 'And your knees go forward and away.',
  };
  for (final entry in migrations.entries) {
    final prompt = await repo.getByUid(entry.key);
    if (prompt != null && prompt.text != entry.value) {
      prompt.text = entry.value;
      await repo.save(prompt);
    }
  }
}
