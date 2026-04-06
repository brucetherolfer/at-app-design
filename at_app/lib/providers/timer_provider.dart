import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prompt_timer_service.dart';

final timerServiceProvider = Provider<PromptTimerService>((ref) {
  return PromptTimerService();
});

/// Countdown remaining duration — updates every second when running.
final countdownProvider = StreamProvider<Duration>((ref) {
  return ref.watch(timerServiceProvider).countdownStream;
});

/// Last prompt text that was fired — for displaying on main screen.
final lastPromptProvider = StateProvider<String?>((ref) => null);

/// Whether a prompt just fired (for triggering animation).
final promptFiredProvider = StateProvider<bool>((ref) => false);

/// Timer running state.
final timerRunningProvider = StateProvider<bool>((ref) => false);

/// Timer paused state.
final timerPausedProvider = StateProvider<bool>((ref) => false);
