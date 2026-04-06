import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/at_card.dart';
import '../../core/widgets/at_row.dart';
import '../../core/widgets/at_section_label.dart';
import '../../core/widgets/at_toggle.dart';
import '../../models/app_settings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/library_provider.dart';
import '../../providers/sequence_provider.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final libraries = ref.watch(librariesProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Backdrop
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(color: AppColors.sheetBackdrop),
          ),
          // Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.76,
              ),
              decoration: const BoxDecoration(
                color: AppColors.sheetBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.sheetDragHandle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('SETTINGS', style: AppTextStyles.sheetTitle),
                  ),
                  // Scrollable content
                  Flexible(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      children: [
                        // ── Mode ──────────────────────────────────────
                        const ATSectionLabel(label: 'Mode', isFirst: true),
                        ATCard(children: [
                          ATRow(
                            label: 'Delivery Mode',
                            sublabel: settings.deliveryMode == DeliveryMode.free
                                ? 'Free — prompts throughout the day'
                                : 'Sequence — ordered set on timer',
                            trailing: _ModeToggle(
                              value: settings.deliveryMode,
                              onChanged: (m) => notifier.setDeliveryMode(m),
                            ),
                          ),
                        ]),

                        // ── Interval ──────────────────────────────────
                        const ATSectionLabel(label: 'Interval'),
                        ATCard(children: [
                          ATRow(
                            label: 'Interval Type',
                            sublabel: settings.intervalType == IntervalType.fixed
                                ? 'Fixed'
                                : 'Random',
                            trailing: ATToggle(
                              value: settings.intervalType == IntervalType.random,
                              onChanged: (v) => notifier.setIntervalType(
                                  v ? IntervalType.random : IntervalType.fixed),
                            ),
                          ),
                          if (settings.intervalType == IntervalType.fixed)
                            ATRow(
                              label: 'Every',
                              trailing: _Stepper(
                                value: settings.fixedIntervalMinutes,
                                unit: 'min',
                                min: 1,
                                max: 120,
                                onChanged: (v) => notifier.setFixedInterval(v),
                              ),
                            )
                          else ...[
                            ATRow(
                              label: 'Minimum',
                              trailing: _Stepper(
                                value: settings.minIntervalMinutes,
                                unit: 'min',
                                min: 1,
                                max: settings.maxIntervalMinutes - 1,
                                onChanged: (v) => notifier.setRandomInterval(
                                    v, settings.maxIntervalMinutes),
                              ),
                            ),
                            ATRow(
                              label: 'Maximum',
                              trailing: _Stepper(
                                value: settings.maxIntervalMinutes,
                                unit: 'min',
                                min: settings.minIntervalMinutes + 1,
                                max: 180,
                                onChanged: (v) => notifier.setRandomInterval(
                                    settings.minIntervalMinutes, v),
                              ),
                            ),
                          ],
                        ]),

                        // ── Prompts ───────────────────────────────────
                        const ATSectionLabel(label: 'Prompts'),
                        ATCard(children: [
                          ATRow(
                            label: 'Order',
                            sublabel: settings.promptOrder == PromptOrder.random
                                ? 'Random'
                                : 'Sequential',
                            trailing: ATToggle(
                              value: settings.promptOrder == PromptOrder.sequential,
                              onChanged: (v) => notifier.setPromptOrder(
                                  v ? PromptOrder.sequential : PromptOrder.random),
                            ),
                          ),
                          ATRow(
                            label: 'Library',
                            sublabel: libraries.isNotEmpty
                                ? libraries
                                    .firstWhere(
                                      (l) => l.uid == settings.primaryLibraryUid,
                                      orElse: () => libraries.first,
                                    )
                                    .name
                                : '—',
                            trailing: const Icon(Icons.chevron_right,
                                color: Color(0x47F0F0F0), size: 18),
                            onTap: () => context.push('/library'),
                          ),
                          ATRow(
                            label: 'Alternate Library',
                            sublabel: settings.alternateLibraryUid != null &&
                                    libraries.isNotEmpty
                                ? libraries
                                    .firstWhere(
                                      (l) =>
                                          l.uid == settings.alternateLibraryUid,
                                      orElse: () => libraries.first,
                                    )
                                    .name
                                : 'Off',
                            trailing: ATToggle(
                              value: settings.alternateLibraryUid != null,
                              onChanged: (v) => notifier.setAlternateLibrary(
                                v
                                    ? (libraries.length > 1
                                        ? libraries
                                            .firstWhere((l) =>
                                                l.uid !=
                                                settings.primaryLibraryUid)
                                            .uid
                                        : null)
                                    : null,
                              ),
                            ),
                          ),
                        ]),

                        // ── Audio ─────────────────────────────────────
                        const ATSectionLabel(label: 'Audio'),
                        ATCard(children: [
                          ATRow(
                            label: 'Audio Mode',
                            sublabel: _audioModeLabel(settings.audioMode),
                            trailing: const Icon(Icons.chevron_right,
                                color: Color(0x47F0F0F0), size: 18),
                          ),
                          ATRow(
                            label: 'Chime',
                            sublabel: _chimeLabel(settings.selectedChime),
                            trailing: const Icon(Icons.chevron_right,
                                color: Color(0x47F0F0F0), size: 18),
                          ),
                        ]),

                        // ── Visual ────────────────────────────────────
                        const ATSectionLabel(label: 'Visual'),
                        ATCard(children: [
                          ATRow(
                            label: 'Visual Mode',
                            sublabel: settings.visualMode == VisualMode.night
                                ? 'Night (Moon)'
                                : 'Day (Orb)',
                            trailing: ATToggle(
                              value: settings.visualMode == VisualMode.day,
                              onChanged: (v) => notifier.setVisualMode(
                                  v ? VisualMode.day : VisualMode.night),
                            ),
                          ),
                        ]),

                        // ── Manage ────────────────────────────────────
                        const ATSectionLabel(label: 'Manage'),
                        ATCard(children: [
                          ATRow(
                            label: 'Blackout Windows',
                            trailing: const Icon(Icons.chevron_right,
                                color: Color(0x47F0F0F0), size: 18),
                            onTap: () => context.push('/blackout'),
                          ),
                          ATRow(
                            label: 'Sequences',
                            trailing: const Icon(Icons.chevron_right,
                                color: Color(0x47F0F0F0), size: 18),
                            onTap: () => context.push('/sequences'),
                          ),
                          ATRow(
                            label: 'Library Manager',
                            trailing: const Icon(Icons.chevron_right,
                                color: Color(0x47F0F0F0), size: 18),
                            onTap: () => context.push('/library'),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _audioModeLabel(AudioMode mode) {
    switch (mode) {
      case AudioMode.silent:
        return 'Silent';
      case AudioMode.tone:
        return 'Tone';
      case AudioMode.voice:
        return 'Voice';
      case AudioMode.toneAndVoice:
        return 'Tone + Voice';
    }
  }

  String _chimeLabel(String key) {
    switch (key) {
      case 'bell':
        return 'Soft Bell';
      case 'bowl':
        return 'Tibetan Bowl';
      case 'tone':
        return 'Simple Tone';
      default:
        return key;
    }
  }
}

// ── Mode toggle pill: FREE | SEQ ──────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final DeliveryMode value;
  final ValueChanged<DeliveryMode> onChanged;

  const _ModeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Chip(
          label: 'FREE',
          selected: value == DeliveryMode.free,
          onTap: () => onChanged(DeliveryMode.free),
        ),
        const SizedBox(width: 4),
        _Chip(
          label: 'SEQ',
          selected: value == DeliveryMode.sequence,
          onTap: () => onChanged(DeliveryMode.sequence),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF48CAE4).withOpacity(0.12)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? const Color(0xFF48CAE4).withOpacity(0.45)
                : const Color(0xFFFFFFFF).withOpacity(0.12),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.72,
            color: selected
                ? const Color(0xFF48CAE4).withOpacity(0.85)
                : const Color(0xFFFFFFFF).withOpacity(0.35),
          ),
        ),
      ),
    );
  }
}

// ── Stepper control ───────────────────────────────────────────────────────

class _Stepper extends StatelessWidget {
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: '−',
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.07)),
          SizedBox(
            width: 60,
            height: 30,
            child: Center(
              child: Text(
                '$value $unit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF48CAE4).withOpacity(0.70),
                ),
              ),
            ),
          ),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.07)),
          _StepBtn(
            icon: '+',
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;

  const _StepBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 30,
        child: Center(
          child: Text(
            icon,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(onTap != null ? 0.45 : 0.15),
            ),
          ),
        ),
      ),
    );
  }
}
