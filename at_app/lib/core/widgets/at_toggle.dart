import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ATToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ATToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? AppColors.toggleTrackOn : AppColors.toggleTrackOff,
          border: Border.all(
            color: value ? AppColors.toggleBorderOn : AppColors.toggleBorderOff,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 16 : 4,
              top: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.toggleThumbOn : AppColors.toggleThumbOff,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
