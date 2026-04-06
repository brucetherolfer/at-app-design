import 'package:flutter/material.dart';

class NightOrb extends StatefulWidget {
  final bool isActive; // true = prompt just fired → bloom
  final bool isStopped;

  const NightOrb({
    super.key,
    required this.isActive,
    required this.isStopped,
  });

  @override
  State<NightOrb> createState() => _NightOrbState();
}

class _NightOrbState extends State<NightOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnim;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    _breathAnim = Tween<double>(begin: 0.965, end: 1.035).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    if (!widget.isStopped) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NightOrb old) {
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
    final opacity = widget.isStopped ? 0.38 : 1.0;

    return AnimatedBuilder(
      animation: _breathAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isStopped ? 1.0 : _breathAnim.value,
          child: Opacity(
            opacity: opacity,
            child: SizedBox(
              width: 320,
              height: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow (animated on active)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.ease,
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00B4E4)
                                    .withOpacity(0.55),
                                blurRadius: 60,
                                spreadRadius: 28,
                              ),
                              BoxShadow(
                                color: const Color(0xFF0096C7)
                                    .withOpacity(0.32),
                                blurRadius: 110,
                                spreadRadius: 55,
                              ),
                              BoxShadow(
                                color: const Color(0xFF006EAA)
                                    .withOpacity(0.16),
                                blurRadius: 190,
                                spreadRadius: 90,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: const Color(0xFF0096C7)
                                    .withOpacity(0.35),
                                blurRadius: 50,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: const Color(0xFF0078AF)
                                    .withOpacity(0.20),
                                blurRadius: 95,
                                spreadRadius: 45,
                              ),
                              BoxShadow(
                                color: const Color(0xFF005A91)
                                    .withOpacity(0.10),
                                blurRadius: 160,
                                spreadRadius: 80,
                              ),
                            ],
                    ),
                  ),
                  // Moon image with teal tint
                  ClipOval(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                        widget.isActive
                            ? _tealMatrix(2.8, 1.2)
                            : _tealMatrix(2.2, 0.92),
                      ),
                      child: Image.asset(
                        'assets/images/moon-sphere.png',
                        width: 260,
                        height: 260,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Produces a sepia(1) hue-rotate(150deg) saturate(s) brightness(b) matrix
  List<double> _tealMatrix(double saturation, double brightness) {
    // Approximate teal tint: boost blue/cyan, reduce red/green
    final s = saturation * brightness;
    return [
      0.07 * s, 0.10 * s, 0.50 * s, 0, 0,
      0.07 * s, 0.35 * s, 0.58 * s, 0, 0,
      0.10 * s, 0.50 * s, 0.95 * s, 0, 0,
      0,        0,        0,        1, 0,
    ];
  }
}
