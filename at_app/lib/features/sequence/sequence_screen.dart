import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/inner_screen_scaffold.dart';
import '../../core/widgets/at_card.dart';
import '../../core/widgets/at_row.dart';
import '../../core/widgets/at_section_label.dart';
import '../../core/widgets/at_toggle.dart';
import '../../models/sequence.dart';
import '../../models/app_settings.dart';
import '../../providers/sequence_provider.dart';
import '../../providers/settings_provider.dart';

class SequenceScreen extends ConsumerWidget {
  const SequenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sequencesAsync = ref.watch(sequencesProvider);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return InnerScreenScaffold(
      title: 'Sequence Manager',
      body: sequencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sequences) {
          final builtIn = sequences.where((s) => s.isBuiltIn).toList();
          final custom = sequences.where((s) => !s.isBuiltIn).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              // Auto-fire toggle
              const ATSectionLabel(label: 'Auto-Fire', isFirst: true),
              ATCard(children: [
                ATRow(
                  label: 'Auto-fire sequences',
                  sublabel: settings.sequenceTrigger == SequenceTrigger.timer
                      ? 'Every ${settings.sequenceTimerMinutes} min'
                      : 'On demand only',
                  trailing: ATToggle(
                    value: settings.sequenceTrigger == SequenceTrigger.timer,
                    onChanged: (v) => notifier.setSequenceTrigger(
                        v ? SequenceTrigger.timer : SequenceTrigger.onDemand),
                  ),
                ),
                if (settings.sequenceTrigger == SequenceTrigger.timer)
                  ATRow(
                    label: 'Interval',
                    trailing: _Stepper(
                      value: settings.sequenceTimerMinutes,
                      min: 5,
                      max: 240,
                      step: 5,
                      unit: 'min',
                      onChanged: (v) => notifier.setSequenceTimerMinutes(v),
                    ),
                  ),
              ]),

              const ATSectionLabel(label: 'Built-in Sequences'),
              ATCard(
                children: builtIn
                    .map((s) => _SequenceRow(
                          sequence: s,
                          isActive: settings.activeSequenceUid == s.uid,
                          onSelect: () => notifier.setActiveSequence(s.uid),
                        ))
                    .toList(),
              ),

              if (custom.isNotEmpty) ...[
                const ATSectionLabel(label: 'Custom Sequences'),
                ATCard(
                  children: custom
                      .map((s) => _SequenceRow(
                            sequence: s,
                            isActive: settings.activeSequenceUid == s.uid,
                            onSelect: () => notifier.setActiveSequence(s.uid),
                          ))
                      .toList(),
                ),
              ],

              const SizedBox(height: 12),
              _AddButton(
                onTap: () => _showCreateDialog(context, ref),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0C1D2E),
        title: const Text('New Sequence',
            style: TextStyle(color: Colors.white70)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Sequence name',
            hintStyle: TextStyle(color: Colors.white30),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.tealPrimary.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                ref
                    .read(sequenceNotifierProvider.notifier)
                    .createSequence(ctrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Create',
                style: TextStyle(color: AppColors.tealPrimary.withOpacity(0.9))),
          ),
        ],
      ),
    );
  }
}

class _SequenceRow extends StatelessWidget {
  final Sequence sequence;
  final bool isActive;
  final VoidCallback onSelect;

  const _SequenceRow({
    required this.sequence,
    required this.isActive,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ATRow(
      label: sequence.name,
      sublabel:
          '${sequence.promptUids.length} prompts · ${sequence.gapSeconds}s gap',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.tagActiveBg,
                border: Border.all(color: AppColors.tagActiveBorder),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ACTIVE',
                style: AppTextStyles.tagLabel
                    .copyWith(color: AppColors.tagActiveTeal),
              ),
            )
          else
            GestureDetector(
              onTap: onSelect,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'SELECT',
                style: AppTextStyles.tagLabel.copyWith(
                  color: AppColors.tealPrimary.withOpacity(0.55),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.dashedBg,
          border: Border.all(color: AppColors.dashedBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            '+ ADD SEQUENCE',
            style: AppTextStyles.pillLabel.copyWith(
              fontSize: 12,
              letterSpacing: 0.96,
              color: AppColors.dashedText,
            ),
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final String unit;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: value > min ? () => onChanged(value - step) : null,
          behavior: HitTestBehavior.opaque,
          child: Text(
            '−',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(value > min ? 0.45 : 0.15),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$value $unit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.tealPrimary.withOpacity(0.70),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: value < max ? () => onChanged(value + step) : null,
          behavior: HitTestBehavior.opaque,
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(value < max ? 0.45 : 0.15),
            ),
          ),
        ),
      ],
    );
  }
}
