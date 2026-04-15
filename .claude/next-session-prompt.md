# AT App — Next Session Handoff

## Project
Flutter iOS app for Alexander Technique awareness prompts. Primary user: Bruce (RMT, Salt Spring Island BC).

**Install command (always use release — debug builds white-screen when opened without flutter run):**
```
PATH="/opt/homebrew/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  flutter run --release -t lib/main_at.dart -d 00008110-001A60A11A9B601E
```
Simulator: `flutter run -t lib/main_at.dart -d 7B432A2D-308A-4126-A2B4-8E55AF3FFF38`

Read `CLAUDE.md`, `AT APP/CLAUDE.md`, `.claude/dev-diary.md`, `.claude/lessons.md`, `.claude/build-list.md` before starting anything.

---

## State at handoff

Release build installed on Bruce's iPhone. Codebase committed and pushed to GitHub (main).

### What's working ✓
- **Background delivery** — batch OS notifications (64-slot rolling window) fire on schedule even when Dart isolate is suspended. Actual AT prompt texts in each notification. ✓
- **Chime in banner notifications** — `.caf` sound files in iOS bundle play the user's selected chime with each batch notification (mute switch must be OFF). ✓
- **Siri Announce** — with headphones in, Siri reads the full prompt text. ✓
- **Native Swift keepalive** — AppDelegate runs AVAudioPlayer + 3s Timer in Swift, independent of Dart. Keeps AVAudioSession alive. ✓
- **Audio ducking** — music lowers during prompts, restores after (like Apple Reminders). Scoped to prompt delivery only — `duckOthers` applied in `_duckForPrompt()`, removed in `_restoreMix()` with full silent loop reinit after. Works on lock screen, with/without headphones. ✓
- **Pre-recorded voice files** — FM's Directions (`fms_dir_001`) and FM's Sequence (`fms_seq_001–004`) play Daniel (British male) voice via `just_audio` instead of TTS. Falls back to TTS for all other prompts. ✓
- **All core timer controls** — Start/Stop/Pause/Resume/SkipForward/SkipBack/FireNow ✓
- **Sequence mode** — fires library in order with configurable gap; manual or timed trigger ✓
- **Alternating libraries** — separate sequential counters for primary vs alternate ✓
- **All built-in libraries** — All Prompts (197), Bruce's (44), MIO (16), FM's Directions, FM's Sequence, Classic AT Modified (13), Bodyscan Full (48), Bodyscan Joints Anat (29), Bodyscan Joints Plain (29), Questions (88) ✓
- **Blackout windows** — overnight logic fixed; enable/disable toggle; Sleep window seeded ✓

### Key architecture insight (Session 13)
Dart isolate does NOT suspend in practice — the native Swift keepalive is too effective. Live Dart TTS fires every prompt through the locked screen, cancelling the corresponding batch slot before it plays. Batch notifications are a safety net only. This means voice through lock screen already works natively — no Siri needed.

Pre-recorded voice files play via `just_audio` directly (not via notification sounds — that path was tried and confirmed non-functional because live fires always cancel batch slots first).

---

## Next priorities (in order)

### 1. Time Sensitive Notifications — one Xcode GUI step
Code is complete (`InterruptionLevel.timeSensitive` already set, entitlement file exists). Just needs Xcode GUI:
- Open `ios/Runner.xcworkspace` in Xcode
- Runner target → Signing & Capabilities → + → "Time Sensitive Notifications"
- Xcode registers with Apple Developer portal and regenerates provisioning profile
- Without this: prompts are blocked by Focus modes (Do Not Disturb, Sleep, etc.)

### 2. App icon
Still the default Flutter icon. Needs a real AT-flavored icon before App Store submission (and just looks more professional on Bruce's phone now).

### 3. Blackout window indicator on main screen
When inside a blackout window, prompts silently stop with no explanation — countdown just resets. Add a label/indicator on the main screen ("Blackout active" or similar) so Bruce knows why nothing is firing.

---

## Voice files architecture (for future expansion)
- `_voiceAssets` map in `AudioService` (prompt UID → m4a asset path) is the extension point
- Add new voice files to `assets/audio/`, add entry to map
- **Per-library voice assignment** is in build-list.md as a nice-to-have — different voice per library, especially powerful with alternating libraries (two different voices = harder to ignore, stronger conditioning)
- Current test files use Daniel (British male macOS TTS) — replace with better voices later

---

## Architecture — background delivery
- `lib/services/notification_service.dart` — `scheduleBatch()` schedules 64 `zonedSchedule` notifications. `_voiceCaf(uid)` maps prompt UIDs to voice .caf files (for if batch ever does fire). `_chimeCaf(key)` maps chime key to .caf filename.
- `lib/services/prompt_timer_service.dart` — `_buildBatchData()` returns `(texts, uids)` tuples. `_deliverPrompt()` passes `promptUid` to `AudioService.playPrompt()`.
- `lib/services/audio_service.dart` — `_voiceAssets` map, `_voiceFilePlayer` for pre-recorded files, `_duckForPrompt()` / `_restoreMix()` for scoped ducking.
- `ios/Runner/AppDelegate.swift` — native silent loop + 3s keepalive timer. Session uses `mixWithOthers` only (no permanent `duckOthers`).
