import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/inner_screen_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InnerScreenScaffold(
      title: 'About',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
        children: [
          // App identity
          Text(
            'Alexander Technique App',
            style: AppTextStyles.navTitle.copyWith(
              fontSize: 18,
              color: AppColors.tealPrimary.withOpacity(0.90),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A timed prompt delivery app for Alexander Technique practitioners. '
            'Delivers awareness prompts throughout the day — in free mode or as ordered sequences.',
            style: TextStyle(
              color: AppColors.rowSubtext,
              fontSize: 14,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 40),

          // Image credits section
          _SectionHeading('Image Credits'),
          const SizedBox(height: 12),
          _CreditBlock(
            title: 'Moon photograph',
            body: '"Full Moon" by Gregory H. Revera\n'
                'Wikimedia Commons — CC BY-SA 3.0\n'
                'https://commons.wikimedia.org/wiki/File:FullMoon2010.jpg',
          ),

          const SizedBox(height: 40),

          // Audio credits section
          _SectionHeading('Audio Credits'),
          const SizedBox(height: 12),
          _CreditBlock(
            title: 'Tibetan Bowl',
            body: 'Pixabay — Royalty-free, no attribution required',
          ),
          const SizedBox(height: 14),
          _CreditBlock(
            title: 'Soft Bell',
            body: 'Pixabay — Royalty-free, no attribution required',
          ),
          const SizedBox(height: 14),
          _CreditBlock(
            title: 'Simple Tone',
            body: 'Mixkit — Royalty-free, no attribution required',
          ),

          const SizedBox(height: 40),

          // Built by
          _SectionHeading('Built for'),
          const SizedBox(height: 12),
          Text(
            'Bruce — RMT and Alexander Technique practitioner, Salt Spring Island, BC.',
            style: TextStyle(
              color: AppColors.rowSubtext,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: AppColors.sectionLabel,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _CreditBlock extends StatelessWidget {
  final String title;
  final String body;
  const _CreditBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.rowText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: TextStyle(
            color: AppColors.rowSubtext,
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
