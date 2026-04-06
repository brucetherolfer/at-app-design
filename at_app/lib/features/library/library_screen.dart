import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/inner_screen_scaffold.dart';
import '../../core/widgets/at_card.dart';
import '../../core/widgets/at_row.dart';
import '../../core/widgets/at_section_label.dart';
import '../../models/library.dart';
import '../../models/prompt.dart';
import '../../providers/library_provider.dart';
import '../../providers/repository_providers.dart';

const _uuid = Uuid();

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final librariesAsync = ref.watch(librariesProvider);

    return InnerScreenScaffold(
      title: 'Library Manager',
      body: librariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (libraries) {
          final builtIn = libraries.where((l) => l.isBuiltIn).toList();
          final custom = libraries.where((l) => !l.isBuiltIn).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              const ATSectionLabel(label: 'Built-in Libraries', isFirst: true),
              ATCard(
                children: builtIn.map((lib) => _LibraryRow(library: lib)).toList(),
              ),
              const ATSectionLabel(label: 'Custom Libraries'),
              if (custom.isNotEmpty)
                ATCard(
                  children: custom.map((lib) => _LibraryRow(library: lib)).toList(),
                ),
              const SizedBox(height: 12),
              _AddLibraryButton(onTap: () => _showAddDialog(context, ref)),
            ],
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0C1D2E),
        title: const Text('New Library', style: TextStyle(color: Colors.white70)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Library name',
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF48CAE4), width: 0.3),
            ),
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
                    .read(libraryNotifierProvider.notifier)
                    .createLibrary(ctrl.text.trim());
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

class _LibraryRow extends ConsumerWidget {
  final Library library;
  const _LibraryRow({required this.library});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptCount =
        ref.watch(promptsByLibraryProvider(library.uid)).valueOrNull?.length;

    return ATRow(
      label: library.name,
      sublabel: promptCount != null ? '$promptCount prompts' : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (library.isBuiltIn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.tagActiveBg,
                border: Border.all(color: AppColors.tagTealBorder),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'BUILT-IN',
                style: AppTextStyles.tagLabel.copyWith(
                  color: AppColors.tagTeal,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right,
              color: Colors.white.withOpacity(0.28), size: 18),
        ],
      ),
      onTap: () => _openLibrary(context, library),
    );
  }

  void _openLibrary(BuildContext context, Library library) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LibraryDetailScreen(library: library),
      ),
    );
  }
}

class _AddLibraryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddLibraryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.dashedBg,
          border: Border.all(color: AppColors.dashedBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            '+ ADD LIBRARY',
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

// ── Library Detail ─────────────────────────────────────────────────────────

class LibraryDetailScreen extends ConsumerStatefulWidget {
  final Library library;
  const LibraryDetailScreen({super.key, required this.library});

  @override
  ConsumerState<LibraryDetailScreen> createState() =>
      _LibraryDetailScreenState();
}

class _LibraryDetailScreenState extends ConsumerState<LibraryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final promptsAsync =
        ref.watch(promptsByLibraryProvider(widget.library.uid));

    return InnerScreenScaffold(
      title: widget.library.name,
      body: promptsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (prompts) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              ATSectionLabel(
                label: '${prompts.length} Prompts',
                isFirst: true,
              ),
              if (prompts.isNotEmpty)
                ATCard(
                  children: prompts
                      .map((p) => _PromptRow(
                            prompt: p,
                            isBuiltIn: widget.library.isBuiltIn,
                            onDelete: () => _deletePrompt(p),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 12),
              if (!widget.library.isBuiltIn)
                _AddLibraryButton(
                  onTap: () => _showAddPromptDialog(context),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deletePrompt(Prompt prompt) async {
    await ref.read(promptRepositoryProvider).delete(prompt.uid);
  }

  void _showAddPromptDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0C1D2E),
        title: const Text('Add Prompt', style: TextStyle(color: Colors.white70)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Prompt text',
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
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final prompts = await ref
                    .read(promptRepositoryProvider)
                    .getByLibrary(widget.library.uid);
                final prompt = Prompt()
                  ..uid = _uuid.v4()
                  ..text = ctrl.text.trim()
                  ..libraryUid = widget.library.uid
                  ..sortOrder = prompts.length
                  ..isBuiltIn = false
                  ..createdAt = DateTime.now();
                await ref.read(promptRepositoryProvider).save(prompt);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text('Add',
                style: TextStyle(color: AppColors.tealPrimary.withOpacity(0.9))),
          ),
        ],
      ),
    );
  }
}

class _PromptRow extends StatelessWidget {
  final Prompt prompt;
  final bool isBuiltIn;
  final VoidCallback onDelete;

  const _PromptRow({
    required this.prompt,
    required this.isBuiltIn,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ATRow(
      label: prompt.text,
      trailing: isBuiltIn
          ? null
          : GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.close,
                  size: 16, color: Colors.white.withOpacity(0.28)),
            ),
    );
  }
}
