import 'package:flutter/material.dart';

class DayOrb extends StatefulWidget {
  final bool isActive;
  final bool isStopped;

  const DayOrb({
    super.key,
    required this.isActive,
    required this.isStopped,
  });

  @override
  State<DayOrb> createState() => _DayOrbState();
}

class _DayOrbState extends State<DayOrb> with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _breathAnim = Tween<double>(begin: 0.93, end: 1.07).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    if (!widget.isStopped) _breathController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(DayOrb old) {
    super.didUpdateWidget(old);
    if (widget.isStopped) {
      _breathController.stop();
    } else if (!_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isStopped ? 1.0 : _breathAnim.value,
          child: Opacity(
            opacity: widget.isStopped ? 0.35 : 1.0,
            child: CustomPaint(
              size: const Size(375, 375),
              painter: _DayOrbPainter(isActive: widget.isActive),
            ),
          ),
        );
      },
    );
  }
}

class _DayOrbPainter extends CustomPainter {
  final bool isActive;
  _DayOrbPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Layer 1: Outer — #0096c7, radius 119, opacity 0.60 / 0.85
    _drawLayer(canvas, center, 119, const Color(0xFF0096C7),
        isActive ? 0.85 : 0.60, 40);
    // Layer 2: Mid — #48cae4, radius 90, opacity 0.70 / 0.95
    _drawLayer(canvas, center, 90, const Color(0xFF48CAE4),
        isActive ? 0.95 : 0.70, 28);
    // Layer 3: Core — #90e0ef, radius 63, opacity 0.65 / 0.90
    _drawLayer(canvas, center, 63, const Color(0xFF90E0EF),
        isActive ? 0.90 : 0.65, 20);
    // Layer 4: Bright — #caf0f8, radius 49, opacity 0.45 / 0.75
    _drawLayer(canvas, center, 49, const Color(0xFFCAF0F8),
        isActive ? 0.75 : 0.45, 14);
  }

  void _drawLayer(Canvas canvas, Offset center, double radius, Color color,
      double opacity, double blur) {
    final paint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur)
      ..shader = RadialGradient(
        colors: [color.withOpacity(opacity), color.withOpacity(0)],
        stops: const [0.0, 1.0],
      ).createShader(
          Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_DayOrbPainter old) => old.isActive != isActive;
}
