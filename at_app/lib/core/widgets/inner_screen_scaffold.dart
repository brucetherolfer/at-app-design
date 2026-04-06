import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'at_background.dart';

class InnerScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const InnerScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ATBackground(
        nightMode: true,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nav bar
              SizedBox(
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back button
                    Positioned(
                      left: 16,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: AppColors.tealPrimary.withOpacity(0.85),
                              size: 20,
                            ),
                            Text(
                              'Back',
                              style: AppTextStyles.navBack.copyWith(
                                color: AppColors.tealPrimary.withOpacity(0.60),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Title
                    Text(
                      title.toUpperCase(),
                      style: AppTextStyles.navTitle,
                    ),
                    // Actions
                    if (actions != null)
                      Positioned(
                        right: 16,
                        child: Row(children: actions!),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0x0DFFFFFF)),
              // Content
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
