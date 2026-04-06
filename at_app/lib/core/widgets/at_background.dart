import 'package:flutter/material.dart';

/// Full-screen background gradient — same base for both visual modes.
/// Night mode uses this; day mode uses the same gradient (slightly adjusted).
class ATBackground extends StatelessWidget {
  final Widget child;
  final bool nightMode;

  const ATBackground({
    super.key,
    required this.child,
    this.nightMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.16), // 50% x, 42% y
          radius: 1.1,
          colors: nightMode
              ? const [
                  Color(0xFF162E44), // 0%
                  Color(0xFF0C1D2E), // 38%
                  Color(0xFF050E18), // 65%
                  Color(0xFF010508), // 100%
                ]
              : const [
                  Color(0xFF0D2137),
                  Color(0xFF071525),
                  Color(0xFF030C18),
                  Color(0xFF010508),
                ],
          stops: nightMode
              ? const [0.0, 0.38, 0.65, 1.0]
              : const [0.0, 0.40, 0.75, 1.0],
        ),
      ),
      child: child,
    );
  }
}
