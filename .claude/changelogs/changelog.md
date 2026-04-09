# Changelog

## [Unreleased]

### Fixed
- **Settings sheet live-update** — converted `SettingsSheet` to `ConsumerStatefulWidget` with local shadow state; toggles and steppers now update instantly without waiting for Isar → Riverpod → modal propagation
- **Back button on Library Detail** — `LibraryDetailScreen` was pushed via `Navigator.push` (breaking `context.pop()`); now pushed via `context.push('/library/detail', extra: library)` through GoRouter so back button works correctly
- **Library row in settings** — was incorrectly navigating to Library Manager; now opens an `_LibraryPickerDialog` to select the active prompt library
- **Audio Mode row** — had no `onTap`; now opens `_AudioModePickerDialog` with all 4 modes (Silent / Tone / Voice / Tone + Voice) with descriptions
- **"+ ADD LIBRARY" shown inside Library Detail** — `_AddLibraryButton` had hardcoded label; renamed to `_AddButton` with `label` param; detail screen correctly shows "+ ADD PROMPT"
- **Alternate Library — no way to pick which library** — toggle turning ON now opens a library picker (excluding primary); row tap when on opens picker to change selection; snackbar shown if no eligible libraries exist

### Added
- `/library/detail` GoRouter route (accepts `Library` via `state.extra`)
- `_LibraryPickerDialog` — reusable AlertDialog picker for selecting a library with checkmark on current selection
- `_AudioModePickerDialog` — AlertDialog picker for Audio Mode with sublabel descriptions per mode

---

## [0.2.0] — 2026-04-08

### Added
- **8 built-in prompt libraries** with real AT content from Bruce's spreadsheet CSVs:
  - All Prompts (197), Bruce's Prompts (44), MIO Prompts (16)
  - Classic AT — FM's (6), Classic AT — Modified (13)
  - Bodyscan Full (48), Bodyscan Joints Anatomical (29), Bodyscan Joints Plain Language (29)
- **4 built-in sequences**: Primary Control (empty/TBD), Bodyscan Full, Bodyscan Joints Anatomical, Bodyscan Joints Plain Language
- Deterministic UIDs for bodyscan sequence prompts (`bs_full_001`, `bs_ja_001`, `bs_jp_001`) for stable cross-referencing
- `simple_tone.m4a` — processed cooking bell (loudnorm -16 LUFS, AAC 128k, 1.58s, Mixkit license)
- `fmsLibrary`, `modifiedClassicLibrary`, `bodyscanFullLibrary`, `bodyscanJointsAnatLibrary`, `bodyscanJointsPlainLibrary` getters in seed_data.dart
- `fmsPrompts`, `modifiedClassicPrompts`, `bodyscanFullPrompts`, `bodyscanJointsAnatPrompts`, `bodyscanJointsPlainPrompts` getters

### Changed
- `seed_data.dart` — replaced all placeholder prompts with real AT content
- `main_at.dart` — `_seedIfNeeded()` now seeds all 8 libraries and 4 sequences
- `main_general.dart` — same as main_at.dart (kept in sync)
- Bodyscan sequences use 4s gap (vs 2s for free-mode sequences)
- Removed old `bodyScanSequence` and `preActivitySequence` getters (replaced by specific bodyscan variants)

---

## [0.1.0] — 2026-04-07

### Added
- Full Flutter project scaffold at `at_app/`
- Two-flavor architecture: `at` (com.brucetherolfer.atapp) and `general` (com.brucetherolfer.atappgeneral)
- **5 screens**: MainScreen, SettingsScreen, LibraryScreen, SequenceScreen, BlackoutScreen
- **Models**: Prompt, Library, Sequence, BlackoutWindow, AppSettings (Isar collections)
- **Repositories**: LibraryRepository, PromptRepository, SequenceRepository, SettingsRepository, IsarService
- **Services**: AudioService, NotificationService, PromptTimerService
- **Providers**: settingsProvider, promptTimerProvider, libraryProvider, sequenceProvider
- **Orbs**: DayOrb (CustomPainter radial gradient), NightOrb (moon photo + teal ColorFilter), RippleRings
- Breathing animation: 6s ease-in-out, scale 0.965→1.035 (night), 0.93→1.07 (day)
- Pavlov conditioning audio: chime plays non-blocking, voice overlaps during decay
- Per-sound voice delay map: bell=800ms, bowl=1600ms, tone=400ms
- System notification sound as default (AudioMode.silent + playSound:true on notifications)
- 3 processed audio chimes: tibetan_bowl.m4a (44s), soft_bell.m4a (24s), simple_tone.m4a (1.58s)
- `build-list.md` tracking pre-submission requirements
- Placeholder seed data (3 libraries, 200+9+23 prompts, 3 empty sequences)

### Fixed
- `SettingsNotifier.update` conflict with `AsyncNotifierBase.update` → renamed to `_save()`
- `FlutterTts.setRate()` → `setSpeechRate()`
- `test/widget_test.dart` referencing deleted `MyApp` → stub test
- `unawaited` not found → `import 'dart:async'` in audio_service.dart
