import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class PromptTextWidget extends StatefulWidget {
  final String? text;
  const PromptTextWidget({super.key, this.text});

  @override
  State<PromptTextWidget> createState() => _PromptTextWidgetState();
}

class _PromptTextWidgetState extends State<PromptTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<double> _translateAnim;
  String? _displayText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    );
    _translateAnim = Tween<double>(begin: 4, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    );
  }

  @override
  void didUpdateWidget(PromptTextWidget old) {
    super.didUpdateWidget(old);
    if (widget.text != old.text && widget.text != null) {
      _displayText = widget.text;
      _controller.forward(from: 0).then((_) {
        // Hold for 4s then dismiss
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) _controller.reverse();
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: Transform.translate(
            offset: Offset(0, _translateAnim.value),
            child: SizedBox(
              width: 320,
              child: Text(
                _displayText ?? '',
                style: AppTextStyles.promptText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
