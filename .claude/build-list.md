# AT App — Build List

Things remaining before App Store submission, tracked here as they come up.

---

## Must-have before submission

- [ ] **About / Credits screen** — Required for moon photo attribution (Gregory H. Revera, CC BY-SA 3.0). One screen, accessible from Settings. One line of credit text.
- [ ] **Background execution validation** — Must test on a physical iPhone. Confirm prompts fire when app is backgrounded for 30+ minutes, screen is locked, and audio plays on locked screen.
- [ ] **AppDelegate.swift** — Configure AVAudioSession for locked-screen audio playback (playback category).
- [ ] **Sequence prompt content** — Built-in sequences (Primary Control, Body Scan, Pre-Activity) have empty `promptUids`. Assign actual prompts before Sequence Mode is usable.
- [ ] **Blackout window seed data** — Confirm Bruce's massage schedule times (Mon/Tue/Thu/Fri) and pre-populate as defaults on first launch.
- [ ] **App name — final decision** — Working name "Alexander Technique App". Confirm before App Store submission (check trademark).
- [ ] **App icon** — Replace default Flutter icon with AT-flavored icon for both flavors.
- [ ] **iOS flavor schemes** — Xcode schemes for AT and General flavors (currently Android-only flavors are configured).

## Nice to have before v1

- [ ] **Voice picker UI** — Settings row to browse and select TTS voice from available device voices.
- [ ] **Chime preview** — Tap a chime in Settings to hear it before selecting.
- [ ] **Onboarding flow** — First-launch screen explaining the app and requesting notification permissions gracefully.
- [ ] **Web background disclaimer** — Banner on web version noting that prompts require the tab to stay open.

## Deferred to v2

- [ ] General Public flavor — second flavor build after AT v1 ships
- [ ] Prompt categories (Lying / Sitting / Walking / General) — data not yet assigned
- [ ] ElevenLabs voice cloning / AI voice
- [ ] Custom sound file import
- [ ] Gamification, streaks, progress tracking

---

## Audio ✅
All three chimes processed and committed:
- `tibetan_bowl.m4a` — 44s, Pixabay (no attribution required)
- `soft_bell.m4a` — 24s, Pixabay (no attribution required)
- `simple_tone.m4a` — 0.5s, Mixkit (no attribution required)

Moon photo — **attribution required** in About screen:
> "Moon" by Gregory H. Revera, Wikimedia Commons, CC BY-SA 3.0
