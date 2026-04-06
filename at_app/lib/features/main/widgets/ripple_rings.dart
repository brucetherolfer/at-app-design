import 'package:flutter/material.dart';

class RippleRings extends StatefulWidget {
  final bool trigger; // flip this true to trigger a new ripple burst

  const RippleRings({super.key, required this.trigger});

  @override
  State<RippleRings> createState() => _RippleRingsState();
}

class _RippleRingsState extends State<RippleRings>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  bool _lastTrigger = false;

  @override
  void initState() {
    super.initState();
    _createControllers();
  }

  @override
  void didUpdateWidget(RippleRings old) {
    super.didUpdateWidget(old);
    if (widget.trigger && !_lastTrigger) {
      _fireRipple();
    }
    _lastTrigger = widget.trigger;
  }

  void _createControllers() {
    for (int i = 0; i < 3; i++) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      );
      _controllers.add(c);
    }
  }

  void _fireRipple() async {
    for (int i = 0; i < _controllers.length; i++) {
      final c = _controllers[i];
      c.reset();
      await Future.delayed(Duration(milliseconds: 500 * i));
      c.forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _controllers.map((c) {
        return AnimatedBuilder(
          animation: c,
          builder: (_, __) {
            if (c.value == 0 && !c.isAnimating) return const SizedBox.shrink();
            final scale = 1.0 + c.value * 1.4; // 1 → 2.4
            final opacity = (0.4 * (1 - c.value)).clamp(0.0, 1.0);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF48CAE4).withOpacity(opacity),
                    width: 1,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
