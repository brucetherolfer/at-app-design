# CLAUDE.md — General Public App Flavor

This is the **general public flavor** of the Alexander Technique (AT) reminder app. It lives inside the larger AT APP workspace. Read this file before working in this directory.

---

## What This Is

A second app flavor spun off from the AT-specific reminder app. Same core engine — background prompt delivery, configurable intervals, audio modes, blackout windows — but with less AT-specific language, targeting somatic wellness and posture awareness practitioners broadly.

The AT app is built first. This flavor slots in via Flutter's flavor architecture without structural changes.

---

## Parent Project Context

The full product spec lives at the workspace root:
- `../project-design.md` — comprehensive design doc (canonical reference)
- `../AT_App_Spec_Sheet.txt` — product spec sheet
- `../AT_App_Context.md` — origin context and current status

---

## App Overview

**Core concept:** Timed awareness prompts delivered throughout the day. Works on locked/sleeping phone.

**Delivery modes:**
- **Free Mode** — prompts fire at random or fixed intervals from the active library
- **Sequence Mode** — ordered set of prompts fires in rapid succession (every ~2 sec), triggered on demand or on a timer

**Audio modes:** Silent | Tone | Voice (OS TTS) | Tone + Voice (Pavlov conditioning mode)

**Key features:** Prompt libraries (built-in + custom), blackout windows by day/time, random or sequential prompt order, live countdown on main screen, manual trigger

---

## Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart) — iOS, Android, Web |
| State management | Riverpod |
| Local storage | Hive or Isar |
| TTS | flutter_tts |
| Audio | just_audio or audioplayers |
| Background execution | flutter_background_service |
| Notifications | flutter_local_notifications |
| Flavor system | Flutter `--flavor` flag |

**Build command:**
```
flutter run --flavor general -t lib/main_general.dart
flutter build ios --flavor general -t lib/main_general.dart
```

---

## Flavor Differences from AT Flavor

| | AT Flavor | General Public Flavor |
|---|---|---|
| App name | "Alexander Technique" (TBD final name) | TBD |
| Default library | AT prompts (200 built-in) | General somatic/posture prompts |
| Language | AT-specific (inhibition, direction, primary control) | Accessible, non-AT-specific |
| Bundle ID | `com.bruce.at` (example) | `com.bruce.general` (example) |
| Primary color | TBD per design spec | TBD per design spec |

Flavor is controlled at build time via `AppFlavor` constants — not stored in the database.

---

## Current Work in This Directory

`torus-ui/` — A Three.js torus visual UI prototype (bloom/glow effect, animated). This is an exploratory UI mockup, not production Flutter code. Related to the animated main screen concept.

Files:
- `index.html` — Three.js torus animation (web prototype)
- `render_torus.py` — Blender render script for torus
- `probe_blender.py` — Blender probe/test script
- `render/` — Rendered output frames

---

## Architecture Notes

- **Flavor architecture is the key constraint** — any structural change to the AT app must remain flavor-compatible
- **No backend at v1** — fully local, no auth, no network
- **Background execution on iOS is the hardest problem** — validate on physical device early; simulators are unreliable for this
- **Dark mode default** across both flavors

---

## What's Deferred to This Flavor (Post-AT v1)

- Final app name and branding
- General-public prompt library content
- Design spec for this flavor's color/typography
- App Store submission for this flavor

---

## Design Defaults (Until Spec Delivered)

- Dark mode
- Pill buttons
- Open, spacious layout
- No faded/tinted backgrounds behind icons or text
- No colored circle backgrounds behind icons — icons stand alone
