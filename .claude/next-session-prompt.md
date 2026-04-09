# AT App — Next Session Handoff

## Project
Flutter iOS app (AT App) for Alexander Technique awareness prompts. Primary user: Bruce (RMT, Salt Spring Island BC). Build command: `PATH="/opt/homebrew/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 flutter build ios -t lib/main_at.dart --release`. Install: `xcrun devicectl device install app --device 00008110-001A60A11A9B601E "build/ios/iphoneos/Runner.app"`. Simulator: `7B432A2D-308A-4126-A2B4-8E55AF3FFF38`.

Read `CLAUDE.md`, `AT APP/CLAUDE.md`, `.claude/dev-diary.md`, `.claude/lessons.md`, `.claude/build-list.md` before starting anything.

## State at handoff
App is installed on Bruce's iPhone and simulator. Core timer runs in background with silent audio loop. Background execution (background/lock screen/simultaneous Spotify) confirmed working.

## Known issues to investigate first
1. **START button still unreliable** — Button flips to STOP visually (local state works), but the timer may not actually start. Root cause unknown — `start()` might be silently failing or hanging at `AudioService().startSilentLoop()` on the physical device. Try/catch now wraps `start()` so it should reset on error, but Bruce needs to confirm it's working. If still broken, add visible error feedback (brief snackbar/alert) so we can see what's happening.

2. **Sequence mode not working** — Bruce confirmed sequence mode (DeliveryMode.sequence) isn't working. Needs investigation: check `PromptTimerService._pickPrompt()` for sequence handling, check `SequenceRepository`, check how `deliveryMode` flows from settings into prompt delivery.

## What works
- Background execution (lock screen, app switching, simultaneous Spotify) ✓
- Silent audio loop keeps iOS from killing the app ✓
- FM's Directions every 7 min as default ✓
- Library migration on launch ✓
- Sleep blackout window seeded (disabled by default) ✓
- Blackout window enable/disable toggle ✓  
- Overnight blackout window support ✓
- Sound switching live (no restart needed) ✓
- Pause button glows teal when active ✓
- Stop/pause race conditions fixed ✓
- Responsive layout (Column + Expanded orb) ✓
- All accessibility scaling fixed (noScaling on all steppers/controls) ✓
- Time-sensitive notifications: code ready (InterruptionLevel.timeSensitive) — needs one Xcode step: Runner target → Signing & Capabilities → + → "Time Sensitive Notifications" to register with Apple portal

## Architecture notes
- `lib/services/prompt_timer_service.dart` — singleton, manages countdown + prompt delivery. All async methods have `if (!_isRunning) return` guards after every await.
- `lib/services/audio_service.dart` — `startSilentLoop()` plays silence.m4a at vol 0 to keep AVAudioSession alive
- `lib/main_at.dart` — runs `_seedIfNeeded()`, `_seedBlackoutsIfNeeded()`, `_migrateLibraries()`, `_migrateFmsPrompts()` on every launch
- State: Riverpod `settingsNotifierProvider` → `settingsProvider` (computed). `_StartStopPill` has local `_localRunning` state for instant visual flip.
