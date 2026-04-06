import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ATSectionLabel extends StatelessWidget {
  final String label;
  final bool isFirst;

  const ATSectionLabel({super.key, required this.label, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        bottom: 10,
        top: isFirst ? 4 : 20,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.sectionLabel.copyWith(
          color: AppColors.sectionLabel,
        ),
      ),
    );
  }
}
