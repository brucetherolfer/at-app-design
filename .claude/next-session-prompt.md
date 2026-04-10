# AT App — Next Session Handoff

## Project
Flutter iOS app for Alexander Technique awareness prompts. Primary user: Bruce (RMT, Salt Spring Island BC).

**Install command (always use release — debug builds white-screen when opened without flutter run):**
```
flutter run --release -t lib/main_at.dart -d 00008110-001A60A11A9B601E
```
Simulator: `flutter run -t lib/main_at.dart -d 7B432A2D-308A-4126-A2B4-8E55AF3FFF38`

Read `CLAUDE.md`, `AT APP/CLAUDE.md`, `.claude/dev-diary.md`, `.claude/lessons.md`, `.claude/build-list.md` before starting anything.

---

## State at handoff

Release build installed on Bruce's iPhone. App runs standalone (close and reopen works). Core timer runs in background with silent audio loop.

### What's working ✓
- Background execution (lock screen, app switching, simultaneous Spotify) ✓
- Audio ducking — music lowers during prompts, restores after (like Apple Reminders) ✓
- Pause button visual state changes immediately on tap ✓
- Sequence mode: fires active library in order with configurable gap ✓
- Sequence trigger: Manual (FIRE only) vs Timed (auto-repeat) ✓
- Gap-between-prompts stepper in settings (SEQ mode only) ✓
- Speech rate stepper in settings (voice modes only) ✓
- Alternating libraries use separate sequential counters (no even/odd skipping) ✓
- Questions library — 88 awareness check-in questions ✓
- All built-in libraries: All Prompts, Bruce's, MIO, FM's Directions, FM's Sequence, Classic AT Modified, Bodyscan Full, Bodyscan Joints (Anat + Plain), Questions ✓
- Accessibility font scaling fixed on all screens ✓
- BACK button not clipped on phone ✓

### Known open items
- **Audio ducking toggle** — ducking is always on for non-silent modes. User may want a setting to disable it (e.g. when not listening to music).
- **Primary Control sequence** — `promptUids` is empty. Bruce to provide prompt text/order.
- **Time-sensitive notifications** — code ready, needs one-time Xcode step: Runner target → Signing & Capabilities → + → "Time Sensitive Notifications"
- **App icon** — still default Flutter icon
- **App name** — working name, confirm before App Store submission

---

## Architecture notes

- `lib/services/audio_service.dart` — `_duckForPrompt()` switches to `duckOthers` before prompt, `_restoreMix()` restores `mixWithOthers` in finally block. `awaitSpeakCompletion(true)` in `init()` makes TTS block until speech finishes (critical — without it duck restores while voice still speaking).
- `lib/services/prompt_timer_service.dart` — `_sequenceBusy` flag prevents concurrent sequence runs. `SequenceTrigger.onDemand` vs `.timer` controls auto-repeat. Separate `lastFiredSequentialIndex` and `lastFiredAltSequentialIndex` counters for primary vs alternate library.
- `lib/main_at.dart` — `_migrateLibraries()` adds new built-in libraries to existing installs on every launch (idempotent, checks by uid).
- `lib/repositories/seed_data.dart` — all built-in data. Questions library: `questionsLibrary` getter + `questionsPrompts` list (88 items).
- State: Riverpod `settingsNotifierProvider`. `_StartStopPill` and `_IconButton` use `StatefulWidget` with local state + `didUpdateWidget` for immediate visual feedback.

---

## Build-list priorities (see `.claude/build-list.md`)
1. Primary Control sequence — waiting on Bruce for prompt text
2. Time-sensitive notifications — one Xcode GUI step
3. App icon
4. App name decision
5. Background execution validation (30+ min locked screen test)
