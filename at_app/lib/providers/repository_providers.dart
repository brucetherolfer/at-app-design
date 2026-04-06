import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/settings_repository.dart';
import '../repositories/library_repository.dart';
import '../repositories/prompt_repository.dart';
import '../repositories/sequence_repository.dart';
import '../repositories/blackout_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(),
);

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(),
);

final promptRepositoryProvider = Provider<PromptRepository>(
  (ref) => PromptRepository(),
);

final sequenceRepositoryProvider = Provider<SequenceRepository>(
  (ref) => SequenceRepository(),
);

final blackoutRepositoryProvider = Provider<BlackoutRepository>(
  (ref) => BlackoutRepository(),
);
