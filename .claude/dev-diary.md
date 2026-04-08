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

## What's next

See `build-list.md` for full tracking. Top priorities:
1. **Bug fixing** — app launched on simulator, bugs being identified
2. **AppDelegate.swift** — AVAudioSession config for locked-screen audio
3. **About/Credits screen** — moon photo attribution (legally required)
4. **Primary Control sequence** — Bruce to provide prompt text
5. **Blackout windows** — seed Bruce's massage schedule
6. **Background execution** — validate on physical device (simulator can't test this)
