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

---

## Session 5 — AppDelegate AVAudioSession + About screen

### AppDelegate.swift — locked-screen audio
Added `AVAudioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])` in `didFinishLaunchingWithOptions`. `.playback` is the iOS category that allows audio to continue when the screen locks or the silent switch is on. `.mixWithOthers` prevents the app from ducking or stopping other audio (ringtones, music) — appropriate for a notification-style app. Without this, just_audio and flutter_tts output would be silenced by the lock screen.

### About & Credits screen
Created `lib/features/about/about_screen.dart` using `InnerScreenScaffold`. Contains:
- App name + one-line description
- Moon photo credit: Gregory H. Revera, Wikimedia Commons, CC BY-SA 3.0 (legally required — this is a copyleft license)
- Audio credits for all three chimes (Pixabay × 2, Mixkit × 1)
- "Built for Bruce" line

Added `/about` route to `app_router.dart` and "About & Credits" row in the settings sheet under a new "About" section label.

---

## Session 6 — Skip back replay, interval seconds, library changes, chime fix, fire on start

### Skip back replays last prompt
Changed `PromptTimerService.skipBack()` from "reset countdown only" to "replay last fired prompt + reset countdown." Added `Prompt? _lastFiredPrompt` field — stored on every `_firePrompt` call. Extracted shared delivery logic into `_deliverPrompt()` so both `_firePrompt` and `_replayPrompt` use the same path (notification + audio + stream). `stop()` clears `_lastFiredPrompt` so stale prompts don't replay across sessions.

### Fixed interval stored in seconds (was minutes)
Renamed `fixedIntervalMinutes` → `fixedIntervalSeconds` in `AppSettings`. Regenerated Isar `.g.dart`. Default changed from 20 min (1200s) to 7 min (420s). Timer service now uses `Duration(seconds: ...)` with a 0-fallback for any device with stale DB schema.

Settings sheet: replaced `_Stepper` for the fixed interval with `_IntervalStepper` — +/- steps by 1 minute (60s), center label auto-formats ("7min", "1hr 30min", "45sec"), tap center opens `_DurationPickerDialog` with H:M:S controls. Minimum interval enforced at 5 seconds.

### Prompt library changes
- Removed "Classic AT — FM's" (6 individual direction prompts)
- Added "FM's Directions" (uid: `builtin_fms_directions`) — 1 prompt, full combined direction: *"Let your neck be free, so your head can go forward and up, and your back lengthen and widen, and your knees can go forward and away."*
- Added "FM's Sequence" (uid: `builtin_fms_sequence`) — 4 prompts with deterministic UIDs (`fms_seq_001–004`) for sequential delivery:
  1. Let your neck be free.
  2. So your head can go forward and up.
  3. And your back lengthen and widen.
  4. And your knees can go forward and away.
- "Classic AT — Modified" kept unchanged

### First-run defaults changed
New user default: FM's Directions library, 7-minute fixed interval. Settings persist across sessions after first launch — seed guard (`if (libs.isNotEmpty) return`) ensures defaults only apply on fresh install.

### Fire prompt immediately on Start
`PromptTimerService.start()` now calls `_firePrompt()` before starting the countdown. First prompt fires the moment the user taps Start — no waiting for the first interval to expire.

### Chime picker fixed
The Chime row in Settings had a chevron but no `onTap` — tapping did nothing. Added `_ChimePickerDialog` (Soft Bell / Tibetan Bowl / Simple Tone) wired to the row. Picker updates local shadow state + persists via `setChime()`.

### About & Credits screen + AppDelegate AVAudioSession (also this session)
See Session 5 entry above.

---

---

## Session 7 — Background execution: silent audio loop + audio_session

### Problem
App stopped the moment the screen locked or another app came to foreground. Spotify killed it entirely.

### Root cause
iOS suspends any app with no active audio session. `UIBackgroundModes: audio` only keeps an app alive if it's actually playing audio. We had the background mode and AVAudioSession configured correctly in AppDelegate, but `just_audio` and `flutter_tts` were reinitialising the session on first use — overwriting our `mixWithOthers` option and dropping it.

### Fix 1 — Silent audio loop
Generated a 2KB silent .m4a (`assets/audio/silence.m4a` via ffmpeg). `AudioService.startSilentLoop()` plays it at volume 0 on `LoopMode.one`. iOS sees an active audio session → keeps the app alive. Called on `start()`, kept alive through `pause()`, stopped only on `stop()`.

### Fix 2 — audio_session package
Added `audio_session: ^0.1.21`. This is the proper companion to `just_audio` — it configures the shared `AVAudioSession` in a way that persists even when `just_audio` / `flutter_tts` reinitialise internally. Configured: category `.playback`, options `.mixWithOthers`.

`mixWithOthers` is the key flag: our audio session coexists with Spotify rather than competing with it. Both play simultaneously. Interruption handler re-activates our session and resumes the silent loop if Spotify temporarily knocked us off.

### Result
- App runs while screen is locked ✓
- App runs while backgrounded ✓  
- Spotify and AT app play simultaneously ✓
- Prompts/chimes fire on top of music ✓

---

## Session 8 — FM's text, blackout toggle, Sleep seed, hit area + accessibility fixes

### FM's prompt text update
User provided the exact canonical wording for FM's Directions. Updated in `seed_data.dart` and added `_migrateFmsPrompts()` to `main_at.dart` — runs on every launch, updates existing installs by UID, no-ops if text already matches. Also corrected seq_003 ("The back can lengthen and widen.") and seq_004 ("And your knees go forward and away.").

### Sleep blackout window
Seeded a "Sleep" window (22:00–07:00, all 7 days, `isEnabled=false`) via `sleepBlackoutWindow` getter in `seed_data.dart`. `_seedBlackoutsIfNeeded()` in `main_at.dart` checks for `builtin_blackout_sleep` on every launch and creates it only if missing — separate guard from the library seed so it runs independently. The window shows up immediately in the Blackout Windows screen, toggle off, as a ready-to-use template.

### Blackout window enable/disable toggle
Added `bool isEnabled = true` to `BlackoutWindow` model (Isar schema regenerated). `_isInBlackout()` now skips disabled windows. Added `toggleEnabled(String uid)` to `BlackoutNotifier`. `_BlackoutRow` now renders a custom mini toggle switch (36×20, animated thumb, teal when on) alongside the existing delete × button.

### Overnight blackout window fix
`_isInBlackout()` previously used `nowMinutes >= start && nowMinutes < end` which breaks when start > end (e.g. 22:00–07:00 = 1320–420). Fixed: when `start > end`, use `nowMinutes >= start || nowMinutes < end`.

### Hit area and accessibility fixes
- `_StartStopPill` GestureDetector: added `HitTestBehavior.opaque` → full pill area tappable, not just the text
- `_IconButton` GestureDetector: same fix
- `MainControls.build()`: wraps in `MediaQuery(textScaler: TextScaler.noScaling)` → accessibility Large Text / Bold Text settings don't reflow or clip the control bar

### Build notes
- Added `PromptRepository.getByUid()` for the migration function
- `BlackoutWindow` Isar schema regenerated with `isEnabled` field
- Build: `flutter build ios -t lib/main_at.dart --release` → 25.2MB
- Installed via `xcrun devicectl device install app` to Bruce's iPhone (`00008110-001A60A11A9B601E`)

---

## Session 9 — Button lockup, race conditions, time-sensitive notifications

### Root cause of START button lockup
`unawaited(PromptTimerService().start())` was silently swallowing any exception thrown inside `start()`. If `AudioService().startSilentLoop()` or `_settingsRepo.load()` threw, the service's `_isRunning` was already set to `true` but no timer ever started. Worse, `_StartStopPill._locked` only released via `didUpdateWidget` (when Riverpod `isRunning` changed) — but if the exception left Riverpod in a stuck state, `_locked` stayed `true` forever, making the button completely unresponsive.

**Fix**: reverted to `await PromptTimerService().start()` with `try/catch` that resets `setRunning(false)` on error. `_StartStopPill._localRunning` already gives instant visual feedback, so `unawaited` wasn't needed for responsiveness.

### Listener.onPointerDown replaced with GestureDetector.onTapDown
`Listener.onPointerDown` bypasses Flutter's gesture recognizer pipeline. On iOS, native gesture recognizers (UIKit-level) can cancel pointer events mid-stream, causing the handler to fire then the touch to be lost. `GestureDetector.onTapDown` participates in Flutter's pipeline correctly and is the right tool here. Added 700ms time-based debounce (not rebuild-based) to prevent double-fire — simpler and more reliable than the previous `didUpdateWidget` approach.

### Stop/pause async race conditions
All async methods in `PromptTimerService` (`start()`, `_scheduleCountdown()` callback, `fireNow()`, `skipBack()`) now check `if (!_isRunning) return` (or `|| _isPaused`) after every `await`. Without these guards: calling `stop()` or `pause()` while a method is mid-await was ignored — the method continued executing, rescheduled the countdown, and fired prompts even after STOP was pressed.

### Pause button glow
The teal tint was 12% opacity — barely visible on the dark background. Increased to 28% fill, solid full-opacity border, added BoxShadow glow. Also unified all enabled icon buttons to full opacity (was 0.7).

### Accessibility fixes — random interval stepper
`_Stepper` (used for random min/max interval) was missing `MediaQuery.noScaling`. On large-font phones the +/- and value text would overflow the fixed-width container. Added same noScaling wrapper as `_IntervalStepper`.

### Time-sensitive notifications
Code complete: `InterruptionLevel.timeSensitive` set in `NotificationService.showPrompt()`. `ios/Runner/Runner.entitlements` created with `com.apple.developer.usernotifications.time-sensitive = true`. However, `CODE_SIGN_ENTITLEMENTS` was NOT added to `project.pbxproj` — the build failed because the existing provisioning profile (auto-managed) doesn't include this capability. The entitlement needs to be added through Xcode GUI: Runner target → Signing & Capabilities → + → "Time Sensitive Notifications". Xcode then registers the capability with the Apple Developer portal and regenerates the profile. Until that step, notifications work at `active` level (not time-sensitive, doesn't break Focus modes).

---

## What's next

See `build-list.md` for full tracking. Top priorities:
1. **Test settings sheet interactivity on device** — all toggles, pickers, steppers, navigation
2. **AppDelegate.swift** — AVAudioSession config for locked-screen audio
3. **About/Credits screen** — moon photo attribution (legally required)
4. **Primary Control sequence** — Bruce to provide prompt text
5. **Blackout windows** — seed Bruce's massage schedule
6. **Background execution** — validate on physical device (simulator can't test this)

---

## Session 11 — Questions library, audio ducking, release build workflow

### Questions prompt library added

Bruce provided 88 awareness check-in questions ("Is your neck free?", "Are you rushing?", etc.) — a different linguistic register from the directive AT prompts. Added as a new built-in library `builtin_questions` with `sortOrder = 8`.

Implementation follows the established pattern: getter in `seed_data.dart` for the library and prompts list, migration check in `main_at.dart` `_migrateLibraries()`. Random UUIDs are fine here (no sequence cross-referencing needed). Library shows up in the library picker immediately on next launch.

### Audio ducking — music lowers when prompt fires

User asked whether background music (Spotify etc.) could temporarily lower during prompts, like Apple Reminders. This is iOS `duckOthers` — the OS drops other audio ~20dB while the active app's audio plays.

The challenge: the silent loop must stay as `mixWithOthers`. A silent audio file still counts as "playing audio" to the OS — if we set `duckOthers` permanently, music would be suppressed the entire time the app is running, not just during prompts.

**Solution**: switch session to `duckOthers` immediately before delivering a prompt (chime/voice), restore `mixWithOthers` in a `finally` block after delivery completes. This means music plays at full volume between prompts and ducks only during the actual chime+speech window.

Implementation in `AudioService.playPrompt()`: three `_duckForPrompt()` / `_restoreMix()` wrappers (one per non-silent mode), both methods use `AudioSession.instance.configure(...)`.

**Bug discovered**: initial test showed a brief glitch at prompt start, not sustained ducking. Root cause: `flutter_tts.speak()` returns a Future that resolves when speech *starts*, not when it *finishes*. So `_restoreMix()` was being called immediately after speech began. Fix: `await _tts.awaitSpeakCompletion(true)` in `init()` — this makes all subsequent `speak()` calls block until speech finishes, so the `finally` block now runs at the right time.

### Debug build white screen on direct open

User encountered white screen when closing the app and reopening by tapping the icon. Root cause: Flutter debug builds on iOS are tied to the `flutter run` host process. When that connection is gone (process killed, Mac sleeping), the Dart VM can't initialize properly and the app shows blank.

**Fix**: always use `flutter run --release` for device installs. Release builds run fully standalone — no host connection needed, opens normally from the home screen, works after reboot. Debug mode should only be used when actively attached for logging/hot reload.

**Command going forward**: `flutter run --release -t lib/main_at.dart -d <device-id>`

---

## Session 10 — Root-cause START fix + sequence mode wired up

### START bug root cause: `await _silentPlayer.play()` hangs forever

The START button was showing STOP (local state worked) but no countdown started and no prompts fired. Root cause traced to `AudioService.startSilentLoop()`:

```dart
await _silentPlayer.setLoopMode(LoopMode.one);
await _silentPlayer.play();   // ← HANGS FOREVER
_silentLoopRunning = true;    // never reached
```

In just_audio, `play()` returns a Future that only completes when the player reaches a non-playing state. With `LoopMode.one`, the player loops indefinitely — the future never resolves. So `start()` was permanently blocked at `await AudioService().startSilentLoop()`, meaning `_scheduleCountdown()` was never called.

The silent audio WAS actually playing (iOS could be seen keeping the app alive in earlier tests), but since `_scheduleCountdown()` was never reached, no prompts were ever queued.

**Fix**: removed the `await` on `_silentPlayer.play()`. Instead, the call is fire-and-forget with a `.catchError` that resets `_silentLoopRunning = false` so subsequent attempts retry. `_silentLoopRunning = true` is now set immediately after firing.

### Sequence mode: never wired into PromptTimerService

`PromptTimerService._firePrompt()` completely ignored `settings.deliveryMode`. It always ran free-mode logic regardless. `SequenceService` existed but was never called.

Additionally, `SequenceService._playSequence()` was looking up prompts by fetching from three hardcoded built-in library UIDs (`'builtin_all'`, `'builtin_bruces'`, `'builtin_mio'`) and doing a linear search — this would miss any custom library prompts. `PromptRepository` already had a `getByUid()` method.

**Fixes**:
1. `PromptTimerService._firePrompt()` now checks `settings.deliveryMode`: if `DeliveryMode.sequence`, delegates to `SequenceService().fireSequence()` and returns. If no `activeSequenceUid`, throws `StateError` that surfaces as a snackbar.
2. `SequenceService._playSequence()` now calls `_promptRepo.getByUid(promptUid)` directly instead of fetching full libraries and doing `firstWhere`. Skips prompts that aren't found (logs a warning) rather than crashing.
