# IRL Time — Spec

A minimal macOS menu-bar time-tracker. Logs sessions (task title, start time, end time, duration) to a local JSON file.

## Tech Stack

- SwiftUI + AppKit (macOS 13+)
- `MenuBarExtra` for status bar presence
- `Combine` (`Timer.publish`) for the tick loop
- JSON log at `~/Library/Application Support/com.nechalmaggon.irltime/timer-log.json`

## Design Language

- Background: `AppBackground` color asset — light `#FAFAF8` / dark `#161616`
- Foreground/numerals: `AppForeground` color asset — light `#1A1A1A` / dark `#F2F2F0`
- Live indicator: `LiveIndicatorGreen` color asset — light `#2E7D32` (deep, for near-white card) / dark `#66BB6A` (brighter, for near-black card)
- Timer display: SF Mono `.system(size: 64, weight: .semibold, design: .monospaced)` + `.monospacedDigit()`
- Task title: proportional `.system(size: 13, weight: .medium, design: .default)` at 50% foreground opacity
- Colors swap automatically with system appearance via named Color assets

## Menu Bar

- Template image icon (`MenuBarIcon.imageset`, SVG, `rendering-intent: template`) — auto-tinted by macOS
- `MenuBarExtra` with "Open IRL Time" (activates window) and "Quit" items

## Timer Display

- Format: `HH:MM` (hours and minutes only — no seconds shown)
- Underlying data layer uses full `Date()` precision; `durationSeconds` is exact

## Checklist

- [x] Core timer (start/stop with `Date()` timestamps)
- [x] JSON log appended on stop (`LogEntry`: taskTitle, startTime, endTime, durationSeconds)
- [x] `HH:MM` display format (seconds suppressed in UI only)
- [x] Monospaced digit timer display (SF Mono 64pt semibold + `.monospacedDigit()`)
- [x] Task title styled distinctly (13pt medium, recedes vs. numerals)
- [x] Color assets (`AppBackground`, `AppForeground`) with light/dark variants
- [x] Menu bar template icon wired via `MenuBarExtra`
- [x] Live indicator dot — 8pt `Circle`, `LiveIndicatorGreen` color token, easeInOut pulse (scale 1→1.35, opacity 1→0.4, 1s repeat), visible only while running, bottom-trailing offset on the timer numeral
- [ ] Title-input flow (inline prompt before start)
- [ ] Flip animation on start/stop
- [ ] Hotkey support
- [ ] Window floating / always-on-top mode
- [ ] Menu bar popover showing live timer (currently opens main window)

## Changelog

- **2026-06-21** — Styling pass: HH:MM display, SF Mono 64pt numerals, task title deprioritised to 13pt medium, `AppBackground`/`AppForeground` named color assets with light/dark variants, SVG template icon + `MenuBarExtra` wired up.
- **2026-06-21** — Live indicator dot: `LiveIndicatorGreen` color asset (light `#2E7D32` / dark `#66BB6A`), 8pt pulsing `Circle` shown bottom-trailing on the timer numeral while running.

## Open / Partial Items

- The `MenuBarExtra` currently shows a dropdown with "Open" / "Quit" — a live-timer popover is not yet implemented.
- The task title shown above the timer falls back to "IRL Time" when the field is empty; once a title is entered and the timer is running it displays the active task name. The text field for entry is still visible below it (no flip/hide animation yet).
- `AppBackground` is applied to the `ContentView` background but the window chrome (title bar area) still reflects the system default; a fully chromeless design is not yet done.
