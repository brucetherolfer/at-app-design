# AT App — Design Spec

Canonical design reference. All values extracted from approved mockups. Use these in Flutter without deviation.

---

## 1. Visual Modes

Three modes are planned. Day and Night are confirmed. Middle is a future candidate.

| Mode | Orb | Background |
|---|---|---|
| Day | SVG plasma orb (teal) | Deep ocean radial gradient |
| Night | Moon photo (teal-tinted) | Near-black radial gradient |
| Middle (future) | Caribbean teal CSS orb | Same as Day |

Default mode: **Night** (dark-first).

---

## 2. Color Palette

### Teal accent (primary)
```
#48cae4   rgba(72, 202, 228, x)   — main teal, all interactive elements
#0096c7   rgba(0, 150, 199, x)    — deeper teal, outer orb layer
#90e0ef                            — light teal, orb core
#caf0f8                            — palest teal, orb bright centre
```

### Backgrounds
```
Day/Night bg (shared):
  radial-gradient(ellipse at 50% 48%, #0d2137 0%, #071525 40%, #030c18 75%, #010508 100%)

Night mode bg (deeper):
  radial-gradient(ellipse 88% 80% at 50% 42%, #162e44 0%, #0c1d2e 38%, #050e18 65%, #010508 100%)
```

### Text
```
Prompt text (fired):          rgba(255, 255, 255, 0.95)
App name / primary UI text:   rgba(240, 240, 240, 0.75)   ← day mode
App name (night, dimmer):     rgba(240, 240, 240, 0.40)
Status text:                  rgba(72, 202, 228, 0.80)    ← day
                              rgba(72, 202, 228, 0.45)    ← night
Countdown label:              rgba(240, 240, 240, 0.55)   ← day
                              rgba(240, 240, 240, 0.20)   ← night
Countdown value:              rgba(72, 202, 228, 0.85)    ← day
                              rgba(72, 202, 228, 0.50)    ← night
Row text (inner screens):     rgba(240, 240, 240, 0.88)
Row subtext:                  rgba(240, 240, 240, 0.28)
Section labels (inner):       rgba(72, 202, 228, 0.35)
Tags / badges:                rgba(72, 202, 228, 0.45–0.70)
```

### Surfaces (inner screens)
```
Card background:   rgba(255, 255, 255, 0.03)
Card border:       rgba(255, 255, 255, 0.07)
Row divider:       rgba(255, 255, 255, 0.05)
```

---

## 3. Typography

Font: `-apple-system` / `SF Pro` on iOS, `Roboto` on Android. No custom fonts.

| Role | Size | Weight | Letter-spacing | Case |
|---|---|---|---|---|
| Prompt text (fired) | 17px | 400 | 0.02em | sentence |
| App name header | 11px | 300 | 0.12em | upper |
| Status text | 10px | 300 | 0.14em | upper |
| Countdown label | 9px | 300 | 0.16em | upper |
| Countdown value | 26px | 200 | 0.04em | — |
| Nav title / sheet title | 12px | 300 | 0.12em | upper |
| Nav back button | 14px | 300 | 0.02em | sentence |
| Section labels (inner) | 9px | 300 | 0.20em | upper |
| Row label | 14px | 300 | 0.01em | sentence |
| Row sublabel | 11px | 300 | 0.02em | sentence |
| Button / pill label | 12px | 300 | 0.12em | upper |
| Tag / badge | 9px | 300 | 0.08em | upper |
| Fire button label | 8px | 300 | 0.12em | upper |

Line height for prompt text: `1.55`. All other text: system default.

Countdown value uses tabular-nums (`font-variant-numeric: tabular-nums` / `FontFeatures([FontFeature.tabularFigures()])`).

---

## 4. Phone Shell (mockup only)

```
Size:           375 × 812 pt
Border-radius:  54px
Border:         1.5px solid #1a2a35 (day) / #0a0a0a (night)
Box shadow:     0 40px 120px rgba(0,0,0,0.8)
Inner ring:     inset 0 0 0 1px rgba(72,202,228,0.04)

Notch:          126 × 34px, centered top, border-radius 0 0 20px 20px
Home indicator: 134 × 5px, bottom 10px, centered, rgba(255,255,255,0.25), border-radius 3px
```

---

## 5. Main Screen Layout

All positions measured from screen edges (375 × 812).

```
App name (header):     top 52px, centered
Settings gear:         top 52px, right 28px, 32×32px tap target
Status text:           top 86px, centered
Orb container:         top 102px → bottom 228px (centred in this zone)
Prompt text:           bottom 248px, centered, width 320px
Countdown label:       bottom 185px + 20px (label above value)
Countdown value:       bottom 185px
Controls:              bottom 50px
```

---

## 6. Day Mode Orb

SVG plasma orb. Four gaussian-blurred ellipses, all centred at 187.5, 187.5 in a 375×375 viewBox.

| Layer | Radius | Fill | Opacity | Blur (stdDev) |
|---|---|---|---|---|
| Outer | 119 | `#0096c7` | 0.60 | 40 |
| Mid | 90 | `#48cae4` | 0.70 | 28 |
| Core | 63 | `#90e0ef` | 0.65 | 20 |
| Bright | 49 | `#caf0f8` | 0.45 | 14 |

**On prompt fire**, layers bloom:

| Layer | Opacity (active) |
|---|---|
| Outer | 0.85 |
| Mid | 0.95 |
| Core | 0.90 |
| Bright | 0.75 |

**Breathing animation:**
```
scale: 0.93 → 1.07
duration: 5s, ease-in-out, infinite
```

**Stopped state:** `animation: none`, `opacity: 0.35`

---

## 7. Night Mode Orb (Moon #2 — preferred)

Asset: `moon-sphere.png` — pre-cropped circular PNG, transparent outside circle.
Credit: Gregory H. Revera, Wikimedia Commons, CC BY-SA 3.0 (attribution required in app's About/credits).

```
Moon image size:   260 × 260px
Container size:    320 × 320px
CSS filter:        sepia(1) hue-rotate(150deg) saturate(2.2) brightness(0.92)
mix-blend-mode:    screen
```

**On prompt fire:**
```
filter:  sepia(1) hue-rotate(150deg) saturate(2.8) brightness(1.2)
transition: 0.8s ease
```

**Glow (box-shadow on container):**
```
idle:
  0 0  50px 20px rgba(0, 150, 199, 0.35),
  0 0  95px 45px rgba(0, 120, 175, 0.20),
  0 0 160px 80px rgba(0,  90, 145, 0.10),
  0 0 240px 110px rgba(0,  60, 110, 0.05)

active:
  0 0  60px 28px rgba(0, 180, 228, 0.55),
  0 0 110px 55px rgba(0, 150, 199, 0.32),
  0 0 190px 90px rgba(0, 110, 170, 0.16),
  0 0 280px 120px rgba(0,  75, 130, 0.08)
```

**Breathing animation:**
```
scale: 0.965 → 1.035
duration: 6s, ease-in-out, infinite
```

**Stopped state:** `animation: none`, `opacity: 0.38`

---

## 8. Ripple Rings

Fired on prompt delivery. Three rings staggered 500ms apart.

```
Size:        200 × 200px circle
Border:      1px solid rgba(72, 202, 228, 0.2)
Animation:   scale 1 → 2.4, opacity 0.4 → 0, 1.8s ease-out
```

---

## 9. Prompt Text Animation

```
Appear:   opacity 0→1, translateY 4px→0, 1s ease
Dismiss:  opacity 1→0, 1s ease (reverse)
Display duration: ~4s before dismiss
```

---

## 10. Buttons

### Primary pill (Start/Stop)
```
Size:           156 × 50px
Border-radius:  25px
Border:         1.5px solid rgba(72, 202, 228, 0.45)
Background:     transparent
Text:           rgba(240, 240, 240, 0.80), 12px, weight 300, 0.12em uppercase

Hover:          border rgba(72,202,228,0.85), bg rgba(72,202,228,0.07), text #f0f0f0
Running state:  border rgba(72,202,228,0.60), bg rgba(72,202,228,0.08)
Transition:     all 0.3s ease
```

### Fire Now / secondary icon buttons
```
Circle:    38 × 38px, border-radius 50%, border 1px solid rgba(240,240,240,0.25)
Label:     8px, weight 300, letter-spacing 0.12em, uppercase, rgba(240,240,240,0.75)
Opacity:   0.5 idle, 0.9 hover
```

### Inner screen pill (e.g. Fire Sequence Now)
```
Full width, height 50px, border-radius 25px
Border:     1.5px solid rgba(72,202,228,0.45)
Background: transparent
Hover:      border rgba(72,202,228,0.85), bg rgba(72,202,228,0.07)
```

### Dashed add button (e.g. Add Prompt)
```
Full width, height 46px, border-radius 14px
Border:     1px dashed rgba(72,202,228,0.25)
Background: rgba(72,202,228,0.04)
Text:       rgba(72,202,228,0.55), 12px, weight 300, 0.08em uppercase
Hover:      border rgba(72,202,228,0.45), bg rgba(72,202,228,0.07)
```

---

## 11. Stepper Control

```
Border:        1px solid rgba(255,255,255,0.10), border-radius 20px, overflow hidden
Button size:   32 × 30px, transparent bg
Button text:   rgba(240,240,240,0.45), 18px
Value cell:    14px, weight 300, rgba(72,202,228,0.70), min-width 44px, centered
               border-left/right: 1px solid rgba(255,255,255,0.07)
Hover:         bg rgba(72,202,228,0.08), text rgba(72,202,228,0.70)
```

---

## 12. Toggle

```
Size:          40 × 24px, border-radius 12px
Off:           bg rgba(72,202,228,0.15), border rgba(72,202,228,0.20)
On:            bg rgba(72,202,228,0.35), border rgba(72,202,228,0.50)
Thumb:         16 × 16px circle
               off: rgba(240,240,240,0.35), translateX 0
               on:  rgba(72,202,228,0.95), translateX 16px
Transition:    0.2s
```

---

## 13. Inner Screens (nav-based)

### Navigation bar
```
Height:        52px, top 44px (below status bar)
Back button:   teal color rgba(72,202,228,0.85), 14px weight 300, opacity 0.6 idle
Title:         12px, weight 300, letter-spacing 0.12em, uppercase, rgba(255,255,255,0.92), centered
```

### Scroll area
```
top: 96px, bottom: 30px
Padding: 8px 20px 40px
No scrollbar visible
```

### Section label
```
9px, weight 300, rgba(72,202,228,0.35), letter-spacing 0.20em, uppercase
margin-bottom: 10px, padding-left: 4px
First label margin-top: 4px, subsequent: 20px
```

### Card
```
Background:    rgba(255,255,255,0.03)
Border:        1px solid rgba(255,255,255,0.07)
Border-radius: 14px
Row divider:   1px solid rgba(255,255,255,0.05) (between rows, not after last)
```

### Standard row
```
Padding:       13–14px vertical, 14–16px horizontal
Min-height:    50–60px
Hover:         bg rgba(255,255,255,0.02)
```

### Tag / badge (inline)
```
9px, weight 300, border-radius 4px, padding 1px 5px
Teal tag:      color rgba(72,202,228,0.45), border rgba(72,202,228,0.20)
Active tag:    color rgba(72,202,228,0.70), border rgba(72,202,228,0.30), bg rgba(72,202,228,0.07)
Built-in tag:  same as teal tag
```

### Drag handle
```
3 horizontal lines, 16px wide × 1.5px tall, gap 3px
Color: rgba(240,240,240,0.90), opacity 0.18
cursor: grab
```

---

## 14. Settings Bottom Sheet

Slides up over main screen (dimmed backdrop). Dismissed by tapping backdrop or dragging down.

```
Background:    rgba(10, 20, 32, 0.97)
Border-radius: 24px 24px 0 0
Max-height:    ~76% of screen
Drag handle:   36 × 4px, border-radius 2px, rgba(255,255,255,0.15), centered, 12px from top

Sheet title:   12px, weight 300, letter-spacing 0.12em, uppercase, rgba(255,255,255,0.92)
Row label:     14px, weight 300, rgba(240,240,240,0.78)
Row sublabel:  11px, weight 300, rgba(240,240,240,0.25)

Backdrop:      rgba(0,0,0,0.55)
Open animation: translateY(100%) → translateY(0), 0.38s cubic-bezier(0.32,0,0.15,1)
```

---

## 15. Scroll Drum (time picker)

Used in Blackout Windows for Start/End time.

```
Visible rows:  3 (previous, selected, next)
Row height:    36px
Selected band: subtle highlight, 1px teal border top/bottom
Fade overlay:  top and bottom gradient fade (transparent → bg color, 30% height each side)
Step:          15 minutes
```

---

## 16. Spacing & Radius Reference

```
Card border-radius:    14px
Pill border-radius:    25px (half of 50px height)
Tag border-radius:     4px
Small cards/icons:     9px
Section gap:           12px between cards
Content padding:       20px horizontal (inner screens), 28px (main screen)
```

---

## 17. Animation Summary

| Element | Animation | Duration | Easing |
|---|---|---|---|
| Day orb breathing | scale 0.93→1.07 | 5s | ease-in-out |
| Night orb breathing | scale 0.965→1.035 | 6s | ease-in-out |
| Ripple ring | scale 1→2.4, opacity 0.4→0 | 1.8s | ease-out |
| Prompt text appear | opacity+translateY | 1s | ease |
| Moon glow/filter | CSS filter + box-shadow | 0.8s | ease |
| Settings sheet open | translateY | 0.38s | cubic-bezier(0.32,0,0.15,1) |
| Toggle thumb | translateX | 0.2s | default |
| Button hover | border/bg | 0.15–0.3s | default |

---

## 18. Alternating Library Mode

Free Mode supports strict alternation between two libraries. Each prompt fires from a different library than the previous one.

**Settings rows (under Prompts section):**

```
Library          [All Prompts ▾]          — primary library, always present
Alternate with   [toggle]  Bruce's 23     — toggle off = disabled, toggle on = reveals alternate library row
Alternate library [Bruce's 23 ▾]          — only visible when Alternate with is ON
```

**Data model:**
- `primaryLibraryId: String`
- `alternateLibraryId: String?` — null when off
- `lastFiredFrom: LibrarySlot` — `.primary` or `.alternate`, persisted across prompts

**Scheduling logic:**
1. On each prompt fire, check `lastFiredFrom`
2. Fire from the other library
3. Update `lastFiredFrom`
4. Pick prompt from that library (random or sequential, per Order setting)

Works with both Fixed and Random interval modes. The two libraries alternate regardless of interval.

**Status text when active:** `Free Mode · All Prompts ↔ Bruce's 23`

---

## 19. Attribution

Moon photo credit (required in app's About screen or credits):
**"Moon" by Gregory H. Revera, Wikimedia Commons, CC BY-SA 3.0**
