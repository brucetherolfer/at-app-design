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
- **Siri Announce** — with headphones in, Siri reads the full prompt text. Effective voice-through-lock. ✓
- **Native Swift keepalive** — AppDelegate runs AVAudioPlayer + 3s Timer in Swift, independent of Dart. Keeps AVAudioSession alive. ✓
- **Audio ducking** — music lowers during prompts, restores after (like Apple Reminders) ✓
- **All core timer controls** — Start/Stop/Pause/Resume/SkipForward/SkipBack/FireNow ✓
- **Sequence mode** — fires library in order with configurable gap; manual or timed trigger ✓
- **Alternating libraries** — separate sequential counters for primary vs alternate ✓
- **All built-in libraries** — All Prompts (197), Bruce's (44), MIO (16), FM's Directions, FM's Sequence, Classic AT Modified (13), Bodyscan Full (48), Bodyscan Joints Anat (29), Bodyscan Joints Plain (29), Questions (88) ✓
- **Blackout windows** — overnight logic fixed; enable/disable toggle; Sleep window seeded ✓

### Known behaviour (by design, not a bug)
- On lock: first prompt fires live (Dart awake → chime + TTS voice). After that, Dart isolate suspends and OS batch notifications take over (chime + banner, no live TTS).
- With Siri Announce on: Siri reads prompt text through headphones for all subsequent prompts.
- Without Siri Announce: chime + banner only (no voice after first prompt).

### The remaining gap — voice through lock
To get live TTS voice through the lock screen without Siri, the options are:

**Option A — Pre-generate TTS audio at session start** (recommended next step)
At `start()`, call `flutter_tts.synthesizeToFile()` for each upcoming prompt → saves as `.m4a` to app documents directory. Batch notifications trigger `just_audio` to play the pre-recorded file. `just_audio` with a local file works from background. Gets Bruce's chosen voice + chime through lock — no Siri. Adds a few seconds prep at session start.

**Option B — `audio_service` package background isolate**
More architecturally correct but significantly more refactoring work. Deferred.

---

## Architecture — background delivery (Session 12)

- `lib/services/notification_service.dart` — `scheduleBatch()` schedules 64 `zonedSchedule` notifications in parallel (`Future.wait`). IDs `2000–2063`. Title `''` (empty) so Siri reads body only. `sound: _chimeCaf(chimeKey)` points to `.caf` filename in bundle. `cancelBatchSlot(index)` cancels the matching OS notification when Dart fires live (prevents double-delivery).
- `lib/services/prompt_timer_service.dart` — `_buildBatchTexts()` pre-calculates actual prompt texts (sequential: peeks from `lastFiredSequentialIndex` without advancing; random: random picks). `_scheduleBatch()` called at start, resume, and after every live fire (rolling window). `chimeKey: settings.selectedChime` passed through.
- `ios/Runner/AppDelegate.swift` — `nativeSilentPlayer` (AVAudioPlayer, `near_silent_native.caf`, loops infinite) + `keepAliveTimer` (every 3s, `.common` run loop mode). Starts on `didEnterBackground`, timer stops on `willEnterForeground`. Handles interruption + media services reset.
- `ios/Runner/` — bundle contains: `near_silent_native.caf`, `soft_bell.caf`, `tibetan_bowl.caf`, `simple_tone.caf` (all pcm_s16le). All four in `project.pbxproj`.
- `assets/audio/near_silent.m4a` — 2-sec pink noise -60dB for Dart-side just_audio silent loop.
- **IMPORTANT:** `flutter_tts` calls `setActive(false)` asynchronously after every utterance. `_reactivateSession()` fires 500ms later in `finally` blocks of `_speak()` and `_playChime()` to counteract. Native 3s timer is belt-and-suspenders.

---

## Open items (see `.claude/build-list.md`)
1. **Voice through lock** — Option A (pre-generate TTS audio) is the cleanest next step
2. **Primary Control sequence** — Bruce to provide prompt text/order
3. **Time-sensitive notifications** — code ready; needs one Xcode GUI step: Runner target → Signing & Capabilities → + → "Time Sensitive Notifications"
4. **App icon** — still default Flutter icon
5. **App name** — working name, confirm before App Store submission
6. **Blackout window indicator on main screen** — when in blackout, show why prompts aren't firing
