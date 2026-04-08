# Lessons — AT App

Mistakes made and rules to follow. Updated after corrections.

---

- [2026-04-07] `SettingsNotifier` named a method `update()` which silently conflicts with `AsyncNotifierBase.update()` — always name custom save/update methods `_save()` or similar to avoid inherited method conflicts in Riverpod AsyncNotifiers.

- [2026-04-07] `FlutterTts` API uses `setSpeechRate()` not `setRate()` — check flutter_tts docs before writing TTS calls, the method names are non-obvious.

- [2026-04-08] CocoaPods is installed at `/opt/homebrew/bin/pod` but not in the default shell PATH used by Claude Code bash commands. Always run flutter iOS commands with `PATH="/opt/homebrew/bin:$PATH" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8` prefixed, otherwise `pod` is not found and the build fails.

- [2026-04-08] `pod install` fails with `Unicode Normalization not appropriate for ASCII-8BIT` if `LANG` is not set. Always set `LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8` when running pod commands.

- [2026-04-08] Flutter iOS simulator builds require CocoaPods even if pods are already installed — flutter re-runs `pod install` on each build. The PATH fix above must be applied to every `flutter run` command, not just the initial `pod install`.

- [2026-04-08] Built-in sequence prompts need **deterministic UIDs** if sequences are to reference them. Random `uuid.v4()` UIDs break cross-referencing because the getter is called fresh each seed. For any prompt that a sequence will reference by UID, use a stable string like `'bs_full_001'`.
