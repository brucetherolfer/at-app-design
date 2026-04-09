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
import '../../models/library.dart';
import '../../providers/settings_provider.dart';
import '../../providers/library_provider.dart';
import '../../providers/sequence_provider.dart';

class SettingsSheet extends ConsumerStatefulWidget {
  const SettingsSheet({super.key});

  @override
  ConsumerState<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<SettingsSheet> {
  // Local shadow of every displayed field — updated immediately on tap
  // so the sheet rebuilds without waiting for Isar → provider → modal propagation
  late DeliveryMode _deliveryMode;
  late IntervalType _intervalType;
  late int _fixedIntervalMinutes;
  late int _minIntervalMinutes;
  late int _maxIntervalMinutes;
  late PromptOrder _promptOrder;
  late String _primaryLibraryUid;
  String? _alternateLibraryUid;
  late AudioMode _audioMode;
  late String _selectedChime;
  late VisualMode _visualMode;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    _deliveryMode = s.deliveryMode;
    _intervalType = s.intervalType;
    _fixedIntervalMinutes = s.fixedIntervalMinutes;
    _minIntervalMinutes = s.minIntervalMinutes;
    _maxIntervalMinutes = s.maxIntervalMinutes;
    _promptOrder = s.promptOrder;
    _primaryLibraryUid = s.primaryLibraryUid;
    _alternateLibraryUid = s.alternateLibraryUid;
    _audioMode = s.audioMode;
    _selectedChime = s.selectedChime;
    _visualMode = s.visualMode;
  }

  // ── Pickers ──────────────────────────────────────────────────────────────

  Future<void> _pickPrimaryLibrary(
      BuildContext context, List<Library> libraries) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => _LibraryPickerDialog(
        title: 'Active Library',
        libraries: libraries,
        currentUid: _primaryLibraryUid,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _primaryLibraryUid = picked);
      ref.read(settingsNotifierProvider.notifier).setPrimaryLibrary(picked);
    }
  }

  Future<void> _pickAlternateLibrary(
      BuildContext context, List<Library> libraries) async {
    // Exclude primary library from the alternate picker
    final eligible =
        libraries.where((l) => l.uid != _primaryLibraryUid).toList();
    if (eligible.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add another library first to use alternating mode.'),
          backgroundColor: Color(0xFF0C1D2E),
        ),
      );
      return;
    }
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => _LibraryPickerDialog(
        title: 'Alternate Library',
        libraries: eligible,
        currentUid: _alternateLibraryUid,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _alternateLibraryUid = picked);
      ref.read(settingsNotifierProvider.notifier).setAlternateLibrary(picked);
    }
  }

  Future<void> _pickAudioMode(BuildContext context) async {
    final picked = await showDialog<AudioMode>(
      context: context,
      builder: (_) => _AudioModePickerDialog(current: _audioMode),
    );
    if (picked != null && mounted) {
      setState(() => _audioMode = picked);
      ref.read(settingsNotifierProvider.notifier).setAudioMode(picked);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final libraries = ref.watch(librariesProvider).valueOrNull ?? [];

    final primaryLibraryName = libraries.isNotEmpty
        ? libraries
            .firstWhere(
              (l) => l.uid == _primaryLibraryUid,
              orElse: () => libraries.first,
            )
            .name
        : '—';

    final alternateLibraryName = _alternateLibraryUid != null &&
            libraries.isNotEmpty
        ? libraries
            .firstWhere(
              (l) => l.uid == _alternateLibraryUid,
              orElse: () => libraries.first,
            )
            .name
        : 'Off';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.76,
      ),
      decoration: const BoxDecoration(
        color: AppColors.sheetBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              children: [
                // ── Mode ──────────────────────────────────────
                const ATSectionLabel(label: 'Mode', isFirst: true),
                ATCard(children: [
                  ATRow(
                    label: 'Delivery Mode',
                    sublabel: _deliveryMode == DeliveryMode.free
                        ? 'Free — prompts throughout the day'
                        : 'Sequence — ordered set on timer',
                    trailing: _ModeToggle(
                      value: _deliveryMode,
                      onChanged: (m) {
                        setState(() => _deliveryMode = m);
                        notifier.setDeliveryMode(m);
                      },
                    ),
                  ),
                ]),

                // ── Interval ──────────────────────────────────
                const ATSectionLabel(label: 'Interval'),
                ATCard(children: [
                  ATRow(
                    label: 'Interval Type',
                    sublabel: _intervalType == IntervalType.fixed
                        ? 'Fixed'
                        : 'Random',
                    trailing: ATToggle(
                      value: _intervalType == IntervalType.random,
                      onChanged: (v) {
                        final next =
                            v ? IntervalType.random : IntervalType.fixed;
                        setState(() => _intervalType = next);
                        notifier.setIntervalType(next);
                      },
                    ),
                  ),
                  if (_intervalType == IntervalType.fixed)
                    ATRow(
                      label: 'Every',
                      trailing: _Stepper(
                        value: _fixedIntervalMinutes,
                        unit: 'min',
                        min: 1,
                        max: 120,
                        onChanged: (v) {
                          setState(() => _fixedIntervalMinutes = v);
                          notifier.setFixedInterval(v);
                        },
                      ),
                    )
                  else ...[
                    ATRow(
                      label: 'Minimum',
                      trailing: _Stepper(
                        value: _minIntervalMinutes,
                        unit: 'min',
                        min: 1,
                        max: _maxIntervalMinutes - 1,
                        onChanged: (v) {
                          setState(() => _minIntervalMinutes = v);
                          notifier.setRandomInterval(v, _maxIntervalMinutes);
                        },
                      ),
                    ),
                    ATRow(
                      label: 'Maximum',
                      trailing: _Stepper(
                        value: _maxIntervalMinutes,
                        unit: 'min',
                        min: _minIntervalMinutes + 1,
                        max: 180,
                        onChanged: (v) {
                          setState(() => _maxIntervalMinutes = v);
                          notifier.setRandomInterval(_minIntervalMinutes, v);
                        },
                      ),
                    ),
                  ],
                ]),

                // ── Prompts ───────────────────────────────────
                const ATSectionLabel(label: 'Prompts'),
                ATCard(children: [
                  ATRow(
                    label: 'Order',
                    sublabel: _promptOrder == PromptOrder.random
                        ? 'Random'
                        : 'Sequential',
                    trailing: ATToggle(
                      value: _promptOrder == PromptOrder.sequential,
                      onChanged: (v) {
                        final next =
                            v ? PromptOrder.sequential : PromptOrder.random;
                        setState(() => _promptOrder = next);
                        notifier.setPromptOrder(next);
                      },
                    ),
                  ),
                  // Library picker row — tap to choose active library
                  ATRow(
                    label: 'Library',
                    sublabel: primaryLibraryName,
                    trailing: const Icon(Icons.chevron_right,
                        color: Color(0x47F0F0F0), size: 18),
                    onTap: () => _pickPrimaryLibrary(context, libraries),
                  ),
                  // Alternate Library — toggle on/off, tap row to change selection
                  ATRow(
                    label: 'Alternate Library',
                    sublabel: alternateLibraryName,
                    trailing: ATToggle(
                      value: _alternateLibraryUid != null,
                      onChanged: (v) {
                        if (v) {
                          // Pick which library to alternate with
                          _pickAlternateLibrary(context, libraries);
                        } else {
                          setState(() => _alternateLibraryUid = null);
                          notifier.setAlternateLibrary(null);
                        }
                      },
                    ),
                    // When alternate is already on, tap row to change the selection
                    onTap: _alternateLibraryUid != null
                        ? () => _pickAlternateLibrary(context, libraries)
                        : null,
                  ),
                ]),

                // ── Audio ─────────────────────────────────────
                const ATSectionLabel(label: 'Audio'),
                ATCard(children: [
                  ATRow(
                    label: 'Audio Mode',
                    sublabel: _audioModeLabel(_audioMode),
                    trailing: const Icon(Icons.chevron_right,
                        color: Color(0x47F0F0F0), size: 18),
                    onTap: () => _pickAudioMode(context),
                  ),
                  ATRow(
                    label: 'Chime',
                    sublabel: _chimeLabel(_selectedChime),
                    trailing: const Icon(Icons.chevron_right,
                        color: Color(0x47F0F0F0), size: 18),
                  ),
                ]),

                // ── Visual ────────────────────────────────────
                const ATSectionLabel(label: 'Visual'),
                ATCard(children: [
                  ATRow(
                    label: 'Visual Mode',
                    sublabel: _visualMode == VisualMode.night
                        ? 'Night (Moon)'
                        : 'Day (Orb)',
                    trailing: ATToggle(
                      value: _visualMode == VisualMode.day,
                      onChanged: (v) {
                        final next = v ? VisualMode.day : VisualMode.night;
                        setState(() => _visualMode = next);
                        notifier.setVisualMode(next);
                      },
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
      behavior: HitTestBehavior.opaque,
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
      behavior: HitTestBehavior.opaque,
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

// ── Library picker dialog ─────────────────────────────────────────────────

class _LibraryPickerDialog extends StatelessWidget {
  final String title;
  final List<Library> libraries;
  final String? currentUid;

  const _LibraryPickerDialog({
    required this.title,
    required this.libraries,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0C1D2E),
      title: Text(title,
          style: const TextStyle(color: Colors.white70, fontSize: 16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: libraries.map((lib) {
            final selected = lib.uid == currentUid;
            return ListTile(
              dense: true,
              title: Text(
                lib.name,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF48CAE4)
                      : Colors.white.withOpacity(0.75),
                  fontSize: 14,
                  fontWeight:
                      selected ? FontWeight.w400 : FontWeight.w300,
                ),
              ),
              trailing: selected
                  ? const Icon(Icons.check,
                      color: Color(0xFF48CAE4), size: 16)
                  : null,
              onTap: () => Navigator.pop(context, lib.uid),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
                color: const Color(0xFF48CAE4).withOpacity(0.6)),
          ),
        ),
      ],
    );
  }
}

// ── Audio mode picker dialog ──────────────────────────────────────────────

class _AudioModePickerDialog extends StatelessWidget {
  final AudioMode current;
  const _AudioModePickerDialog({required this.current});

  static const _modes = [
    AudioMode.silent,
    AudioMode.tone,
    AudioMode.voice,
    AudioMode.toneAndVoice,
  ];
  static const _labels = ['Silent', 'Tone', 'Voice', 'Tone + Voice'];
  static const _sublabels = [
    'No sound',
    'Chime only',
    'Spoken prompt',
    'Chime then voice',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0C1D2E),
      title: const Text('Audio Mode',
          style: TextStyle(color: Colors.white70, fontSize: 16)),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _modes.length,
          itemBuilder: (_, i) {
            final selected = _modes[i] == current;
            return ListTile(
              dense: true,
              title: Text(
                _labels[i],
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF48CAE4)
                      : Colors.white.withOpacity(0.75),
                  fontSize: 14,
                  fontWeight:
                      selected ? FontWeight.w400 : FontWeight.w300,
                ),
              ),
              subtitle: Text(
                _sublabels[i],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                ),
              ),
              trailing: selected
                  ? const Icon(Icons.check,
                      color: Color(0xFF48CAE4), size: 16)
                  : null,
              onTap: () => Navigator.pop(context, _modes[i]),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
                color: const Color(0xFF48CAE4).withOpacity(0.6)),
          ),
        ),
      ],
    );
  }
}
