import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
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
  await NotificationService.init();

  runApp(const ProviderScope(child: AtApp()));
}

Future<void> _seedIfNeeded() async {
  final libRepo = LibraryRepository();
  final libs = await libRepo.getAll();
  if (libs.isNotEmpty) return;

  await libRepo.save(allPromptsLibrary);
  await libRepo.save(brucesLibrary);
  await libRepo.save(mioLibrary);

  final promptRepo = PromptRepository();
  await promptRepo.saveAll(allPrompts);
  await promptRepo.saveAll(brucesPrompts);
  await promptRepo.saveAll(mioPrompts);

  final seqRepo = SequenceRepository();
  await seqRepo.save(primaryControlSequence);
  await seqRepo.save(bodyScanSequence);
  await seqRepo.save(preActivitySequence);

  // Load settings to trigger default creation
  await SettingsRepository().load();
}
