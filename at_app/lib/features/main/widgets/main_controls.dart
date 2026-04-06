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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Skip back
        _IconButton(
          icon: Icons.skip_previous_rounded,
          label: 'BACK',
          onTap: isRunning ? onSkipBack : null,
        ),
        const SizedBox(width: 16),
        // Pause / Resume
        _IconButton(
          icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          label: isPaused ? 'RESUME' : 'PAUSE',
          onTap: isRunning ? onPauseResume : null,
        ),
        const SizedBox(width: 20),
        // Start / Stop pill
        _StartStopPill(
          isRunning: isRunning,
          onTap: onStartStop,
        ),
        const SizedBox(width: 20),
        // Fire Now
        _IconButton(
          icon: Icons.bolt_rounded,
          label: 'FIRE',
          onTap: isRunning ? onFireNow : null,
        ),
        const SizedBox(width: 16),
        // Skip forward
        _IconButton(
          icon: Icons.skip_next_rounded,
          label: 'SKIP',
          onTap: isRunning ? onSkipForward : null,
        ),
      ],
    );
  }
}

class _StartStopPill extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onTap;

  const _StartStopPill({required this.isRunning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 156,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isRunning
                ? AppColors.tealPrimary.withOpacity(0.60)
                : AppColors.tealPrimary.withOpacity(0.45),
            width: 1.5,
          ),
          color: isRunning
              ? AppColors.tealPrimary.withOpacity(0.08)
              : Colors.transparent,
        ),
        child: Center(
          child: Text(
            isRunning ? 'STOP' : 'START',
            style: AppTextStyles.pillLabel,
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _IconButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 0.7 : 0.25,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.fireButtonLabel.copyWith(
                color: Colors.white.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
