# Lessons — AT App

Mistakes made and rules to follow. Updated after corrections.

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
