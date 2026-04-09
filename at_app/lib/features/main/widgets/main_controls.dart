import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class MainControls extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onStartStop;
  final VoidCallback onFireNow;
  final VoidCallback onSkipForward;
  final VoidCallback onSkipBack;
  final VoidCallback onPauseResume;

  const MainControls({
    super.key,
    required this.isRunning,
    required this.isPaused,
    required this.onStartStop,
    required this.onFireNow,
    required this.onSkipForward,
    required this.onSkipBack,
    required this.onPauseResume,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp text scaling so accessibility font sizes don't reflow the control bar.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _IconButton(
            icon: Icons.skip_previous_rounded,
            label: 'BACK',
            onTap: isRunning ? onSkipBack : null,
          ),
          const SizedBox(width: 16),
          _IconButton(
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            label: isPaused ? 'RESUME' : 'PAUSE',
            onTap: isRunning ? onPauseResume : null,
            active: isPaused,
          ),
          const SizedBox(width: 20),
          _StartStopPill(
            isRunning: isRunning,
            onTap: onStartStop,
          ),
          const SizedBox(width: 20),
          _IconButton(
            icon: Icons.bolt_rounded,
            label: 'FIRE',
            onTap: isRunning ? onFireNow : null,
          ),
          const SizedBox(width: 16),
          _IconButton(
            icon: Icons.skip_next_rounded,
            label: 'SKIP',
            onTap: isRunning ? onSkipForward : null,
          ),
        ],
      ),
    );
  }
}

// ── Start / Stop pill ─────────────────────────────────────────────────────
//
// StatefulWidget so it can flip its own visual state the instant the pointer
// touches — without waiting for the Riverpod rebuild. This makes START feel
// as snappy as STOP. didUpdateWidget syncs back to the real state once
// Riverpod propagates.

class _StartStopPill extends StatefulWidget {
  final bool isRunning;
  final VoidCallback onTap;

  const _StartStopPill({required this.isRunning, required this.onTap});

  @override
  State<_StartStopPill> createState() => _StartStopPillState();
}

class _StartStopPillState extends State<_StartStopPill> {
  late bool _localRunning;
  bool _locked = false; // debounce — prevent double-fire within same press

  @override
  void initState() {
    super.initState();
    _localRunning = widget.isRunning;
  }

  @override
  void didUpdateWidget(_StartStopPill old) {
    super.didUpdateWidget(old);
    // Sync local display state whenever it diverges from the real state.
    // Comparing against _localRunning (not old.isRunning) is critical:
    // if Riverpod batches setRunning(true)+setRunning(false) into one rebuild,
    // old.isRunning==widget.isRunning==false so the old check never fired,
    // leaving _localRunning stuck at true. This comparison always corrects it.
    if (_localRunning != widget.isRunning) {
      setState(() => _localRunning = widget.isRunning);
    }
  }

  void _handleDown(TapDownDetails _) {
    if (_locked) return;
    setState(() {
      _locked = true;
      _localRunning = !_localRunning; // flip appearance immediately on touch
    });
    widget.onTap();
    // Release after enough time for start()/stop() to complete.
    // Prevents double-fire and the race condition that Listener.onPointerDown
    // had with iOS native gesture recognizer cancellations.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _locked = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapDown fires before finger lift — instant feel — while still
      // going through Flutter's recognizer pipeline (safe on iOS).
      onTapDown: _handleDown,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Extra padding = larger tap target without changing visual size
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: 156,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: _localRunning
                  ? AppColors.tealPrimary.withOpacity(0.70)
                  : AppColors.tealPrimary.withOpacity(0.50),
              width: 1.5,
            ),
            color: _localRunning
                ? AppColors.tealPrimary.withOpacity(0.10)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              _localRunning ? 'STOP' : 'START',
              style: AppTextStyles.pillLabel,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Icon button (BACK / PAUSE / FIRE / SKIP) ──────────────────────────────

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// When true the button glows teal — used to show PAUSE is active.
  final bool active;

  const _IconButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    // Active state: vivid teal circle with solid border
    // Enabled state: dim white circle
    // Disabled state: very faint
    final iconColor = active ? AppColors.tealPrimary : Colors.white;
    final borderColor = active
        ? AppColors.tealPrimary               // full opacity when glowing
        : Colors.white.withOpacity(0.25);
    final bgColor = active
        ? AppColors.tealPrimary.withOpacity(0.28) // clearly visible tint
        : Colors.transparent;
    final labelColor = active
        ? AppColors.tealPrimary               // matches icon
        : Colors.white.withOpacity(0.75);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.25,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: Border.all(color: borderColor, width: active ? 1.5 : 1.0),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.tealPrimary.withOpacity(0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.fireButtonLabel.copyWith(color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}
