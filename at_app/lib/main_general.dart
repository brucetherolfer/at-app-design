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

  // Seed built-in sequences
  final seqRepo = SequenceRepository();
  await seqRepo.save(primaryControlSequence);
  await seqRepo.save(bodyscanFullSequence);
  await seqRepo.save(bodyscanJointsAnatSequence);
  await seqRepo.save(bodyscanJointsPlainSequence);

  await SettingsRepository().load();
}
