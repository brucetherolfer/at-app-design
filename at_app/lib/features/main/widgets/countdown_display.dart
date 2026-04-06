import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/duration_extensions.dart';
import '../../../models/app_settings.dart';

class CountdownDisplay extends StatelessWidget {
  final Duration remaining;
  final VisualMode visualMode;
  final bool isRunning;

  const CountdownDisplay({
    super.key,
    required this.remaining,
    required this.visualMode,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    final isNight = visualMode == VisualMode.night;
    final labelStyle = isNight
        ? AppTextStyles.countdownLabelNight
        : AppTextStyles.countdownLabelDay;
    final valueStyle = isNight
        ? AppTextStyles.countdownValueNight
        : AppTextStyles.countdownValueDay;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isRunning ? 'NEXT PROMPT' : 'PAUSED',
          style: labelStyle,
        ),
        const SizedBox(height: 4),
        Text(
          isRunning ? remaining.toCountdownString() : '—',
          style: valueStyle,
        ),
      ],
    );
  }
}
