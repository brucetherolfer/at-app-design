# AT App — Dev Diary

## What this project is

A cross-platform Flutter app (iOS primary, Android secondary) that delivers Alexander Technique awareness prompts throughout the day via timed notifications. Works on a locked/sleeping phone. Built for Bruce — an RMT and AT practitioner on Salt Spring Island.

Two-flavor architecture (AT + General Public) built in from day one. AT flavor ships first.

**Primary user:** Bruce. Has massage therapy blackout windows Mon/Tue/Thu/Fri. Wants AT prompts throughout his workday.

---

## Session 1 — Full scaffold + all screens built

Built the entire Flutter project from scratch at `at_app/`. Two-flavor architecture (at + general), all 5 screens, services layer, models, providers, repositories.

**Stack chosen:**
- Flutter 3.41.5 / Dart 3.11.3
- Isar 3.x (local DB, chosen over Hive for better query support)
- Riverpod 2.x (state management, matches user's existing task manager patterns)
- GoRouter (navigation)
- flutter_tts + just_audio (audio)
- flutter_local_notifications + flutter_background_service (background delivery)

**Screens built:**
- `main_screen.dart` — orb animation, live countdown, Start/Stop/Pause/Resume/Skip controls
- `settings_screen.dart` — full settings UI
- `library_screen.dart` — prompt library browser
- `sequence_screen.dart` — sequence manager
- `blackout_screen.dart` — blackout window manager

**Orbs:**
- `day_orb.dart` — CustomPainter 4-layer radial gradient, 5s breathing (0.93→1.07)
- `night_orb.dart` — Moon photo with ColorFilter.matrix teal tint, 6s breathing (0.965→1.035), CSS glow bloom
- `ripple_rings.dart` — 3 rings staggered 500ms, scale 1→2.4, opacity 0.4→0, 1.8s each (fire on prompt delivery)

**Moon photo:** Wikimedia, CC BY-SA 3.0, Gregory H. Revera. Attribution required in About screen.

**Audio design decision — Pavlov conditioning:**
Default audio mode is `AudioMode.silent` (system notification sound plays by default — the user's own iOS chime). toneAndVoice mode plays chime non-blocking then voice overlaps during decay. Per-sound voice delay map:
```dart
static const Map<String, int> _chimeVoiceDelayMs = {
  'bell':  800,
  'bowl':  1600,
  'tone':  400,
};
```

**Key bugs fixed this session:**
- `SettingsNotifier.update` conflicted with `AsyncNotifierBase.update` → renamed to `_save()`
- `FlutterTts.setRate()` undefined → changed to `setSpeechRate()`
- `test/widget_test.dart` referenced deleted `main.dart` → replaced with stub
- `unawaited` not available → added `import 'dart:async'` to audio_service.dart

---

## Session 2 — Real seed data + audio processing

### Audio processing
All three chimes processed with ffmpeg and committed to `assets/audio/`:
- `tibetan_bowl.m4a` — 44.75s, trimmed 14.875s leading silence, loudnorm -16 LUFS, AAC 128k
- `soft_bell.m4a` — 24.3s, aggressive denoise (nf=-40) to remove background static, trimmed, loudnorm, AAC 128k
- `simple_tone.m4a` — 1.58s cooking bell, loudnorm -16 LUFS, AAC 128k (Mixkit, no attribution needed)

### Real seed data
Replaced all placeholder content in `seed_data.dart` with real AT prompts exported from Bruce's spreadsheet as CSVs (in `alexander_prompts_teacher_workbook/`).

**8 built-in libraries seeded:**
| Library | Count | Source |
|---|---|---|
| All Prompts | 197 | All_Prompts CSV |
| Bruce's Prompts | 44 | Bruce's Prompts CSV |
| MIO Prompts | 16 | MIO Prompts CSV |
| Classic AT — FM's | 6 | FM's Prompts CSV (original FM Alexander directions) |
| Classic AT — Modified | 13 | Modified Prompts CSV (contemporary adaptations) |
| Bodyscan — Full | 48 | Bodyscan Full CSV (head to toe) |
| Bodyscan — Joints (Anatomical) | 29 | Bodyscan Joints CSV, anatomical column |
| Bodyscan — Joints (Plain Language) | 29 | Bodyscan Joints CSV, plain language column |

**4 built-in sequences:**
- Primary Control — empty, promptUids TBD (Bruce to provide)
- Bodyscan Full — 48 prompts, 4s gap
- Bodyscan Joints Anatomical — 29 prompts, 4s gap
- Bodyscan Joints Plain Language — 29 prompts, 4s gap

**Architecture note on sequences:**
Bodyscan prompts use **deterministic UIDs** (`bs_full_001`, `bs_ja_001`, `bs_jp_001`) so sequences can reliably reference them. All other library prompts use random `uuid.v4()`.

`main_at.dart` and `main_general.dart` updated to seed all 8 libraries + 4 sequences.

### First device deploy
App deployed to Bruce's iPhone (wirelessly). Build succeeded. "Untrusted Developer" prompt appeared — normal for personal dev cert, fixed by trusting in Settings > General > VPN & Device Management.

**CocoaPods gotcha:** `pod` is at `/opt/homebrew/bin/pod` but not in default PATH. Must run flutter with:
```bash
PATH="/opt/homebrew/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 flutter run ...
```

**Simulator:** iPhone 17 Pro simulator ID `7B432A2D-308A-4126-A2B4-8E55AF3FFF38`. Use for bug fixing — much faster iteration than device deploy.

---

---

## Session 3 — Bug fixing: settings sheet, hit testing, PAUSED state, iOS 26 simulator

### Bugs fixed this session

**Settings buttons non-functional (all except Library button)**
Two-part root cause:
1. `ATRow` wrapped every row in `GestureDetector(behavior: opaque)` even when `onTap == null`, blocking touches from reaching child widgets (toggles, steppers, chips). Fix: skip GestureDetector entirely when `onTap == null`.
2. `ATToggle` was missing `HitTestBehavior.opaque` — only the thumb was tappable, not the full track area.

**Settings sheet not scrolling**
`Column(mainAxisSize: min)` + `Flexible` gives ListView an unbounded height — Flutter can't scroll it. Fix: `mainAxisSize: max` + `Expanded`.

**Settings sheet not visually updating after taps**
`showModalBottomSheet` context is disconnected from the GoRouter ProviderScope — ConsumerWidget inside the modal saves state but never rebuilds. Fix: capture `ProviderScope.containerOf(context)` before opening, thread in via `UncontrolledProviderScope`.

**Back button hidden behind title**
`InnerScreenScaffold` title had no left margin. Fix: `Positioned(left: 70, right: 70)` keeps title clear of back button.

**"PAUSED" showing when STOPPED**
`CountdownDisplay` showed "PAUSED" any time `isRunning=false` — but that's true for both paused AND stopped. Fix: added `isStopped` param; returns `SizedBox.shrink()` when stopped.

### iOS 26 simulator — objective_c.dylib bug (permanent fix)

Flutter's native assets build system has a bug on iOS 26/Xcode 26: it compiles `objective_c.framework` targeting **physical iOS** (Mach-O platform 2) even for simulator builds. The simulator rejects platform-2 dylibs at `dlopen` time. Also, `dlopen` looks for `objective_c.framework/objective_c` at the app bundle root, but it lives in `Frameworks/`.

**Fix baked into Xcode project** (`ios/Runner.xcodeproj/project.pbxproj` build phase `AA1B2C3D4E5F6A7B8C9D0E1F`):
- Runs after all other build phases, simulator only
- Detects wrong platform via `otool -l`
- Recompiles from `~/.pub-cache` source with correct `-target arm64-apple-ios13.0-simulator` flags
- Crucially: also compiles `src/include/dart_api_dl.c` (required for `_Dart_CurrentIsolate_DL` and other Dart DL API symbols — missing this causes a second crash)
- Creates `Runner.app/objective_c.framework → Frameworks/objective_c.framework` symlink for dlopen

Hot reload fails on iOS 26 simulator ("Error while starting Kernel isolate task") — separate Flutter SDK bug. Full restart required for code changes on simulator.

### What's confirmed working
- App launches clean on iOS 26 simulator, no objective_c errors
- PAUSED/STOPPED display correct
- All code changes correct by inspection (settings interactivity needs USB device test)

---

---

## Session 4 — Settings sheet live-update fix + UX bug fixes

### Settings sheet live-update (ConsumerStatefulWidget conversion)

`UncontrolledProviderScope` was in place from Session 3 but wasn't enough — the modal overlay's element tree still didn't receive Riverpod rebuild notifications when state changed. Root cause: GoRouter's ProviderScope and the modal's context are genuinely disconnected at the element tree level; the scope container is shared but rebuild signals don't cross.

**Fix:** Converted `SettingsSheet` from `ConsumerWidget` to `ConsumerStatefulWidget`. State class holds local shadow copies of every displayed field (`_deliveryMode`, `_intervalType`, `_fixedIntervalMinutes`, etc.). Every `onChanged` callback does two things: `setState()` for immediate UI rebuild, then `notifier.setXxx()` for Isar persistence. The sheet now rebuilds instantly on every tap without depending on Riverpod propagation.

### Back button broken on LibraryDetailScreen

`LibraryDetailScreen` was pushed via `Navigator.push(MaterialPageRoute(...))` but `InnerScreenScaffold` calls `context.pop()` (GoRouter). GoRouter's pop operates on its own page stack — it popped the wrong level, going all the way back to `/` instead of back to Library Manager.

**Fix:** Changed `_openLibrary` to `context.push('/library/detail', extra: library)` (GoRouter). Added `/library/detail` route to `app_router.dart`. Now `context.pop()` correctly returns to `/library`.

### Settings sheet UX: 6 bugs fixed

**Library row → Library Manager (wrong destination)**
The "Library" row in Prompts section navigated to `/library` (Library Manager). Needs to be a picker for the active library. Fix: `onTap` now shows `_LibraryPickerDialog` — an AlertDialog listing all libraries with a checkmark on the current one. Tap to select.

**Audio Mode row — no onTap**
Audio Mode row had a chevron but no handler — tapping it did nothing. Fix: `onTap` now shows `_AudioModePickerDialog` — an AlertDialog with all 4 modes (Silent/Tone/Voice/Tone+Voice) with one-line descriptions. Tap to select.

**"+ ADD LIBRARY" label inside Library Detail screen**
`LibraryDetailScreen` reused `_AddLibraryButton` which hardcodes the label. Fix: renamed to `_AddButton` with a `label` parameter. Library Manager uses `'+ ADD LIBRARY'`, Library Detail uses `'+ ADD PROMPT'`.

**Alternate Library — no way to pick which library**
Toggle turning ON auto-picked the first non-primary library. No way to choose. Fix: toggle turning ON now opens `_LibraryPickerDialog` (filtered to exclude primary). Tapping the row when alternate is on opens the picker to change the selection. If only one library exists, shows a snackbar explaining the situation.

**Library vs Library Manager confusion**
Fixed by the two items above: "Library" = picker, "Library Manager" = full management screen. Clear separation.

### Architecture note on dialog-based pickers

Considered using GoRouter route navigation (`context.push('/library/pick')`) from within the settings modal. Decided against: GoRouter pushes to the navigator's page stack on top of the modal route, which works in theory but creates unpredictable ordering when mixing showModalBottomSheet and GoRouter. AlertDialog is simpler, fully modal, and context-safe from within the sheet.

---

## What's next

See `build-list.md` for full tracking. Top priorities:
1. **Test settings sheet interactivity on device** — all toggles, pickers, steppers, navigation
2. **AppDelegate.swift** — AVAudioSession config for locked-screen audio
3. **About/Credits screen** — moon photo attribution (legally required)
4. **Primary Control sequence** — Bruce to provide prompt text
5. **Blackout windows** — seed Bruce's massage schedule
6. **Background execution** — validate on physical device (simulator can't test this)
