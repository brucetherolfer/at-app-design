# AT App — Build List

Things remaining before App Store submission.

---

## Must-have before submission

- [ ] **Bug fixing** — app first launched on simulator, bugs being identified and fixed
- [x] **About / Credits screen** — Moon attribution + audio credits. Accessible from Settings → About & Credits.
- [x] **AppDelegate.swift** — AVAudioSession `.playback` + `.mixWithOthers`. Chimes/TTS play on locked/silent screen.
- [ ] **Background execution validation** — Test on physical iPhone. Confirm prompts fire when app is backgrounded 30+ min, screen locked, audio plays on locked screen.
- [ ] **Primary Control sequence** — `promptUids` is empty. Bruce to provide the prompt text/order.
- [x] **Blackout windows** — Sleep window seeded (10pm–7am, all days, disabled by default). Enable/disable toggle added to each row. Overnight window logic fixed.
- [ ] **App name — final decision** — Working name "Alexander Technique App". Confirm before App Store submission (check trademark).
- [ ] **App icon** — Replace default Flutter icon with AT-flavored icon.
- [ ] **iOS flavor schemes** — Xcode schemes for `at` and `general` flavors (needs Debug-at/Release-at/Profile-at build configs added to Xcode pbxproj).

## Nice to have before v1

- [ ] **Blackout window indicator on main screen** — When currently inside a blackout window, the main screen should show "Blackout window" (or similar) instead of the timer countdown, so the user knows why no prompts are firing. Currently the countdown just keeps resetting silently.


- [ ] **Sequence gap control** — Gap between prompts in sequence mode is currently hardcoded at 2 seconds. Bruce noted 2s works for some sequences but is too fast for body scan. Add a per-sequence or global gap setting (e.g. 1–10 seconds, default 2). Could be a stepper in Settings under a "Sequence" section, or on the sequence screen itself.
- [ ] **Voice picker UI** — Settings row to browse and select TTS voice from device voices.
- [ ] **Per-library voice assignment** — Each library can have its own voice (TTS voice name or pre-recorded file set). When alternating libraries, the two libraries play in different voices — harder to ignore, stronger conditioning signal. UI: voice picker on the library detail screen, or a dedicated voice-per-library matrix in Settings. Architecture: `_voiceAssets` map in AudioService is the foundation; extend to per-library TTS voice selection + pre-recorded file lookup by library UID + prompt UID.
- [ ] **Chime preview** — Tap a chime in Settings to hear it before selecting.
- [ ] **Onboarding flow** — First-launch screen explaining the app, requesting notification permissions gracefully.
- [ ] **Web background disclaimer** — Banner on web version noting prompts require the tab to stay open.

## Deferred to v2

- [ ] General Public flavor — second flavor build after AT v1 ships
- [ ] Prompt categories (Lying / Sitting / Walking / General) — data not yet assigned from spreadsheet
- [ ] ElevenLabs voice cloning / AI voice
- [ ] Custom sound file import
- [ ] Gamification, streaks, progress tracking
- [ ] **Prompt text placement** — on phone, the prompt text at the bottom of the orb area is large. Consider moving it to the row where the skip forward/back/pause buttons sit, replacing or above those labels. This frees the orb for the visual and keeps the text within the control zone.
- [x] **Audio ducking** — implemented. `duckOthers` scoped to prompt delivery window; `mixWithOthers` restored after. Music lowers during chime/voice, returns to full volume between prompts.
- [ ] **Consider removing skip forward/back from main screen** — Bruce raised this. The controls may be clutter for typical use (interval fires, just let it run). Evaluate after real-world testing. If removed, keep the fire-now button. Skip logic can remain in the timer service for programmatic use.

---

## Done ✅

### Audio
- [x] `tibetan_bowl.m4a` — 44s, trimmed leading silence, loudnorm -16 LUFS, AAC 128k (Pixabay, no attribution)
- [x] `soft_bell.m4a` — 24s, aggressive denoise nf=-40, trimmed, loudnorm, AAC 128k (Pixabay, no attribution)
- [x] `simple_tone.m4a` — 1.58s cooking bell, loudnorm, AAC 128k (Mixkit, no attribution)

### Seed data (all real AT content from Bruce's spreadsheets)
- [x] All Prompts library (197 prompts)
- [x] Bruce's Prompts library (44 prompts)
- [x] MIO Prompts library (16 prompts)
- [x] Classic AT — FM's library (6 prompts)
- [x] Classic AT — Modified library (13 prompts)
- [x] Bodyscan Full library + sequence (48 prompts, 4s gap)
- [x] Bodyscan Joints Anatomical library + sequence (29 prompts)
- [x] Bodyscan Joints Plain Language library + sequence (29 prompts)

### App scaffold
- [x] Full Flutter project with two-flavor architecture (at + general)
- [x] All 5 screens (Main, Settings, Library, Sequence, Blackout)
- [x] Isar DB, Riverpod state, GoRouter navigation
- [x] AudioService with Pavlov chime+voice overlap (per-sound delay map)
- [x] NotificationService (system sound default — user's own iOS chime)
- [x] PromptTimerService (background delivery)
- [x] Day orb + Night orb + ripple rings animations
- [x] First build deployed to Bruce's iPhone (wireless)

---

## Notes

**Moon photo attribution (required in About screen):**
> "Moon" by Gregory H. Revera, Wikimedia Commons, CC BY-SA 3.0

**Flutter run command (always use this — pod not in default PATH):**
```bash
cd "AT APP/at_app"
PATH="/opt/homebrew/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  flutter run -t lib/main_at.dart --dart-define=FLAVOR=at -d <device_id>
```

**iPhone 17 Pro simulator ID:** `7B432A2D-308A-4126-A2B4-8E55AF3FFF38`
**Bruce's iPhone device ID:** `00008110-001A60A11A9B601E` (wireless)
