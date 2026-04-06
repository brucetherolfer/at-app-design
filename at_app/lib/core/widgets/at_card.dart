import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ATCard extends StatelessWidget {
  final List<Widget> children;

  const ATCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: _insertDividers(children),
      ),
    );
  }

  List<Widget> _insertDividers(List<Widget> items) {
    if (items.isEmpty) return items;
    final result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.rowDivider,
          indent: 16,
        ));
      }
    }
    return result;
  }
}
