import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/inner_screen_scaffold.dart';
import '../../core/widgets/at_card.dart';
import '../../core/widgets/at_row.dart';
import '../../core/widgets/at_section_label.dart';
import '../../models/blackout_window.dart';
import '../../providers/blackout_provider.dart';

class BlackoutScreen extends ConsumerWidget {
  const BlackoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowsAsync = ref.watch(blackoutWindowsProvider);

    return InnerScreenScaffold(
      title: 'Blackout Windows',
      body: windowsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (windows) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              const ATSectionLabel(
                label: 'Block prompts during these times',
                isFirst: true,
              ),
              if (windows.isNotEmpty)
                ATCard(
                  children: windows
                      .map((w) => _BlackoutRow(
                            window: w,
                            onDelete: () => ref
                                .read(blackoutNotifierProvider.notifier)
                                .deleteWindow(w.uid),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 12),
              _AddButton(
                onTap: () => _showAddDialog(context, ref),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'During blackout windows, prompts are skipped and rescheduled for the next interval.',
                  style: AppTextStyles.rowSublabel,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AddBlackoutSheet(
        onSave: (label, days, start, end) {
          ref.read(blackoutNotifierProvider.notifier).addWindow(
                label: label,
                days: days,
                startTime: start,
                endTime: end,
              );
        },
      ),
    );
  }
}

class _BlackoutRow extends StatelessWidget {
  final BlackoutWindow window;
  final VoidCallback onDelete;

  const _BlackoutRow({required this.window, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final days = window.daysOfWeek.map((d) => dayNames[d - 1]).join(', ');

    return ATRow(
      label: window.label,
      sublabel: '$days · ${window.startTime} – ${window.endTime}',
      trailing: GestureDetector(
        onTap: onDelete,
        child:
            Icon(Icons.close, size: 16, color: Colors.white.withOpacity(0.28)),
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
            '+ ADD BLACKOUT WINDOW',
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

// ── Add Blackout Sheet ─────────────────────────────────────────────────────

class _AddBlackoutSheet extends StatefulWidget {
  final void Function(String label, List<int> days, String start, String end)
      onSave;

  const _AddBlackoutSheet({required this.onSave});

  @override
  State<_AddBlackoutSheet> createState() => _AddBlackoutSheetState();
}

class _AddBlackoutSheetState extends State<_AddBlackoutSheet> {
  final _labelCtrl = TextEditingController();
  final Set<int> _days = {1, 2, 4}; // Mon, Tue, Thu default
  String _start = '09:00';
  String _end = '11:00';

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF70A1420),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.sheetDragHandle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('ADD BLACKOUT WINDOW', style: AppTextStyles.sheetTitle),
          const SizedBox(height: 20),
          // Label field
          TextField(
            controller: _labelCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Label (e.g. Massage Block)',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.tealPrimary.withOpacity(0.25)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.tealPrimary.withOpacity(0.60)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Days
          Text(
            'DAYS',
            style: AppTextStyles.sectionLabel
                .copyWith(color: AppColors.sectionLabel),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(7, (i) {
              final day = i + 1;
              final selected = _days.contains(day);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  if (selected) {
                    _days.remove(day);
                  } else {
                    _days.add(day);
                  }
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.tealPrimary.withOpacity(0.12)
                        : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? AppColors.tealPrimary.withOpacity(0.45)
                          : Colors.white.withOpacity(0.12),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _dayNames[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? AppColors.tealPrimary.withOpacity(0.85)
                          : Colors.white.withOpacity(0.35),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // Time pickers
          Row(
            children: [
              Expanded(
                child: _TimePicker(
                  label: 'Start',
                  value: _start,
                  onChanged: (v) => setState(() => _start = v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _TimePicker(
                  label: 'End',
                  value: _end,
                  onChanged: (v) => setState(() => _end = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Save button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_labelCtrl.text.trim().isNotEmpty && _days.isNotEmpty) {
                widget.onSave(
                  _labelCtrl.text.trim(),
                  _days.toList()..sort(),
                  _start,
                  _end,
                );
                Navigator.pop(context);
              }
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.tealPrimary.withOpacity(0.45),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text('SAVE', style: AppTextStyles.pillLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _TimePicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.sectionLabel
              .copyWith(color: AppColors.sectionLabel),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            final parts = value.split(':');
            final initial = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
            final picked = await showTimePicker(
              context: context,
              initialTime: initial,
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: AppColors.tealPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onChanged(
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColors.tealPrimary.withOpacity(0.25)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColors.tealPrimary.withOpacity(0.70),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
