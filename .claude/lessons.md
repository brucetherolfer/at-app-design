# Lessons — AT App

Mistakes made and rules to follow. Updated after corrections.

---

- [2026-04-09] **`flutter_tts.speak()` resolves when speech *starts*, not when it *ends*.** Wrapping `await _speak()` in a try/finally and calling cleanup in finally runs cleanup immediately after TTS begins — not after it finishes. Fix: call `await _tts.awaitSpeakCompletion(true)` once in `init()`. This makes all `speak()` calls block until completion, so finally blocks and post-speak logic run at the right time.

- [2026-04-09] **Flutter debug builds on iOS show white screen when opened without `flutter run` connected.** Debug builds depend on the host process for Dart VM initialization. If the host connection is gone (process killed, Mac slept), the app shows a blank screen. Always install with `flutter run --release` for physical device testing that needs to survive closing/reopening the app independently.

- [2026-04-09] **`duckOthers` must be scoped to prompt delivery only — not the whole session.** Setting `duckOthers` on the AVAudioSession permanently causes music to be suppressed the entire time the app runs (because the silent loop counts as "active audio"). Switch to `duckOthers` immediately before playing a prompt, restore `mixWithOthers` in a finally block after. This gives Apple Reminders-style ducking without squashing music between prompts.

---

- [2026-04-07] `SettingsNotifier` named a method `update()` which silently conflicts with `AsyncNotifierBase.update()` — always name custom save/update methods `_save()` or similar to avoid inherited method conflicts in Riverpod AsyncNotifiers.

- [2026-04-07] `FlutterTts` API uses `setSpeechRate()` not `setRate()` — check flutter_tts docs before writing TTS calls, the method names are non-obvious.

- [2026-04-08] CocoaPods is installed at `/opt/homebrew/bin/pod` but not in the default shell PATH used by Claude Code bash commands. Always run flutter iOS commands with `PATH="/opt/homebrew/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8` prefixed, otherwise `pod` is not found and the build fails.

- [2026-04-08] `pod install` fails with `Unicode Normalization not appropriate for ASCII-8BIT` if `LANG` is not set. Always set `LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8` when running pod commands.

- [2026-04-08] Flutter iOS simulator builds require CocoaPods even if pods are already installed — flutter re-runs `pod install` on each build. The PATH fix above must be applied to every `flutter run` command, not just the initial `pod install`.

- [2026-04-08] Built-in sequence prompts need **deterministic UIDs** if sequences are to reference them. Random `uuid.v4()` UIDs break cross-referencing because the getter is called fresh each seed. For any prompt that a sequence will reference by UID, use a stable string like `'bs_full_001'`.

- [2026-04-08] When `ATRow` has `onTap == null`, **do not wrap it in a GestureDetector at all** — even `behavior: deferToChild` causes the `RenderDecoratedBox` (from BoxDecoration container) to absorb touches before they reach child widgets. Remove the GestureDetector entirely when there's no tap action.

- [2026-04-08] **Flutter + iOS 26 simulator: `objective_c.framework` native assets bug.** Flutter's native assets build system compiles `objective_c.framework` targeting physical iOS (platform 2) instead of iOS Simulator (platform 7). Fix: add an Xcode Run Script build phase that detects platform 2, recompiles from `~/.pub-cache/hosted/pub.dev/objective_c-*/src/` with `-target arm64-apple-ios13.0-simulator`, and includes `src/include/dart_api_dl.c` (required for Dart DL API symbols). Also create `Runner.app/objective_c.framework → Frameworks/objective_c.framework` symlink for dlopen path resolution.

- [2026-04-08] **`showModalBottomSheet` + Riverpod + GoRouter**: the modal context is disconnected from the ProviderScope used by GoRouter. `ConsumerWidget` inside the modal won't rebuild on state changes. Fix: `final container = ProviderScope.containerOf(context)` before opening, then wrap the sheet widget with `UncontrolledProviderScope(container: container, child: ...)`.

- [2026-04-08] **iOS 26 simulator wireless device install hangs indefinitely.** The `devicectl device install app` command hangs for 30+ minutes over wireless. Always use USB for device deploys. Wireless works for attach/debug but not install.

- [2026-04-08] **`ConsumerWidget` inside `showModalBottomSheet` doesn't rebuild on Riverpod state changes.** Even with `UncontrolledProviderScope`, the modal overlay's element tree doesn't receive rebuild signals. Solution: convert to `ConsumerStatefulWidget` with local shadow state fields. Each `onChanged` calls `setState()` for immediate UI + `notifier.setXxx()` for persistence. Never try to drive a modal bottom sheet from Riverpod watch alone.

- [2026-04-08] **`Navigator.push(MaterialPageRoute(...))` inside a GoRouter app breaks `context.pop()`.** GoRouter's pop operates on its own page stack. Routes pushed imperatively via `Navigator.push` aren't in GoRouter's stack — calling `context.pop()` from those screens pops the wrong level. Always use `context.push('/route', extra: data)` + a matching GoRouter route entry instead of `Navigator.push`.

- [2026-04-08] **Don't reuse a widget with a hardcoded label string when it'll be used in two contexts.** `_AddLibraryButton` hardcoded `'+ ADD LIBRARY'` then was reused for adding prompts. Add a `label` parameter from the start any time a button label might differ by context.

- [2026-04-09] **`unawaited()` silently swallows exceptions — never use for critical service calls.** `unawaited(start())` left `_isRunning=true` with no running timer when `start()` threw. The button locked forever with no visible error. Always `await` critical service calls and wrap in try/catch that resets state on failure.

- [2026-04-09] **`Listener.onPointerDown` is unreliable on iOS — use `GestureDetector.onTapDown` instead.** iOS native gesture recognizers can cancel pointer events mid-gesture, causing `onPointerDown` to fire but the touch to disappear, leaving the button in a broken locked state. `GestureDetector.onTapDown` fires within Flutter's own gesture pipeline and is not subject to native cancellation.

- [2026-04-09] **All async timer/service methods need `if (!_isRunning) return` after every `await`.** If `stop()` is called while `start()` is mid-await, the coroutine continues after the await resumes and re-arms the timer. Every async method that modifies shared timer state must guard after every await: `if (!_isRunning) return;` (and `|| _isPaused` where relevant).

- [2026-04-09] **`await audioPlayer.play()` with `LoopMode.one` hangs forever.** just_audio's `play()` returns a Future that resolves when the player reaches a non-playing state. A looping player never reaches that state, so `await player.play()` never returns. For looping players, always fire without await: `player.play().catchError(...)`. This caused `AudioService.startSilentLoop()` to hang, blocking `PromptTimerService.start()` permanently — the silent loop WAS playing but `_scheduleCountdown()` was never reached.

- [2026-04-09] **`DeliveryMode` enum changes require explicit handling in every dispatch point.** Adding a new `DeliveryMode` value (e.g. `sequence`) does nothing unless every place that switches on delivery mode explicitly handles it. `PromptTimerService._firePrompt()` had no check for `DeliveryMode.sequence` — it silently fell through to free-mode logic. Always audit all callsites when adding enum values.

- [2026-04-10] **Hardware mute switch silences notification sounds even with `InterruptionLevel.timeSensitive`.** `timeSensitive` overrides Focus modes and Do Not Disturb, but NOT the physical mute toggle. Always check hardware mute before debugging sound code. This cost multiple hours of investigation.

- [2026-04-10] **`flutter_tts` calls `AVAudioSession.setActive(false)` asynchronously after each utterance, even with `setSharedInstance(true)`.** A synchronous reactivation immediately after `speak()` loses the race. Use a 500ms delayed `setActive(true)` in the `finally` block to counteract it. Also run a native Swift `Timer` every 3s as belt-and-suspenders.

- [2026-04-10] **`await player.play()` with `LoopMode.one` in just_audio hangs forever — fire without await.** (Confirmed again — this is the same lesson as the silent loop from Session 10. Rule: any looping just_audio player must use `player.play().catchError(...)`, never `await player.play()`.)

- [2026-04-10] **Dart `Timer.periodic` suspends when iOS backgrounds the app, even with `UIBackgroundModes: audio`.** The audio session can be kept alive natively (Swift `AVAudioPlayer` + `Timer` in `RunLoop.main`) but Dart timers stop ticking. For reliable background delivery, pre-schedule OS notifications (`UNNotificationRequest` via `flutter_local_notifications` `zonedSchedule()`). iOS owns these and fires them on schedule regardless of Dart VM state.

- [2026-04-10] **Empty notification title (`''`) causes Siri Announce to read only the body text.** If you set a non-empty title (e.g. `'AT Prompt'`), Siri reads "AT Prompt — [body text]". Empty string makes Siri read only the body, which is what you want for AT prompts.

- [2026-04-09] **Flutter native assets `objective_c.framework` bug affects device builds too, not just simulator.** The framework always comes out with `VersionPlatform=7` (simulator) and an ad-hoc signature regardless of build target. The existing simulator fix script (which exited early for non-simulator) left device builds broken. Fix: extend the build phase script to also handle `$PLATFORM_NAME = "iphoneos"` — recompile targeting `arm64-apple-ios13.0` and re-sign with `$EXPANDED_CODE_SIGN_IDENTITY`. Use Python string pre-escaping (not raw string + replace) to modify pbxproj shellScript values, and verify the closing pattern as `";\n` not `";"` to avoid truncation.
