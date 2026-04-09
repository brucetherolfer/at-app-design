import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/at_background.dart';
import '../../config/app_flavor.dart';
import '../../models/app_settings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/timer_provider.dart';
import '../../providers/library_provider.dart';
import '../../services/prompt_timer_service.dart';
import 'widgets/night_orb.dart';
import 'widgets/day_orb.dart';
import 'widgets/ripple_rings.dart';
import 'widgets/prompt_text_widget.dart';
import 'widgets/countdown_display.dart';
import 'widgets/main_controls.dart';
import '../settings/settings_sheet.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _promptFired = false;
  String? _lastPromptText;

  @override
  void initState() {
    super.initState();
    // Listen for prompt fires from the timer service
    PromptTimerService().promptFiredStream.listen((text) {
      if (mounted) {
        setState(() {
          _promptFired = !_promptFired; // toggle to trigger ripple
          _lastPromptText = text;
        });
        ref.read(lastPromptProvider.notifier).state = text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final countdownAsync = ref.watch(countdownProvider);
    final remaining = countdownAsync.valueOrNull ?? Duration.zero;
    final isNight = settings.visualMode == VisualMode.night;
    final isRunning = settings.isRunning;
    final isPaused = settings.isPaused;

    // Status text
    final library = ref.watch(libraryByUidProvider(settings.primaryLibraryUid));
    final altLibrary = settings.alternateLibraryUid != null
        ? ref.watch(libraryByUidProvider(settings.alternateLibraryUid!))
        : null;
    final statusText = _buildStatusText(settings, library?.name, altLibrary?.name);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ATBackground(
        nightMode: isNight,
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar: app name + settings gear ───────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      AppFlavor.appDisplayName.toUpperCase(),
                      style: isNight
                          ? AppTextStyles.appNameNight
                          : AppTextStyles.appNameDay,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          final container =
                              ProviderScope.containerOf(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => UncontrolledProviderScope(
                              container: container,
                              child: const SettingsSheet(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.settings_outlined,
                          size: 22,
                          color: AppColors.tealPrimary.withOpacity(0.55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Status text ──────────────────────────────────────────────
              Text(
                statusText,
                style: isNight
                    ? AppTextStyles.statusNight
                    : AppTextStyles.statusDay,
              ),

              // ── Orb (fills all remaining space) ─────────────────────────
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RippleRings(trigger: _promptFired),
                      if (isNight)
                        NightOrb(
                          isActive: _promptFired,
                          isStopped: !isRunning,
                        )
                      else
                        DayOrb(
                          isActive: _promptFired,
                          isStopped: !isRunning,
                        ),
                    ],
                  ),
                ),
              ),

              // ── Prompt text ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: PromptTextWidget(text: _lastPromptText),
              ),

              const SizedBox(height: 12),

              // ── Countdown ────────────────────────────────────────────────
              CountdownDisplay(
                remaining: remaining,
                visualMode: settings.visualMode,
                isRunning: isRunning && !isPaused,
                isStopped: !isRunning,
              ),

              const SizedBox(height: 28),

              // ── Controls ─────────────────────────────────────────────────
              MainControls(
                isRunning: isRunning,
                isPaused: isPaused,
                onStartStop: () => _handleStartStop(settings),
                onFireNow: () => PromptTimerService().fireNow(),
                onSkipForward: () => PromptTimerService().fireNow(),
                onSkipBack: () => PromptTimerService().skipBack(),
                onPauseResume: () => _handlePauseResume(),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleStartStop(AppSettings settings) async {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    if (settings.isRunning) {
      PromptTimerService().stop();
      await notifier.setRunning(false);
      await notifier.setPaused(false);
    } else {
      await PromptTimerService().start();
      await notifier.setRunning(true);
      await notifier.setPaused(false);
    }
  }

  Future<void> _handlePauseResume() async {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    if (PromptTimerService().isPaused) {
      await PromptTimerService().resume();
      await notifier.setPaused(false);
    } else {
      PromptTimerService().pause();
      await notifier.setPaused(true);
    }
  }

  String _buildStatusText(
      AppSettings settings, String? libName, String? altLibName) {
    if (!settings.isRunning) return 'STOPPED';
    if (settings.isPaused) return 'PAUSED';

    final mode = settings.deliveryMode == DeliveryMode.free
        ? 'FREE MODE'
        : 'SEQUENCE MODE';
    final lib = libName ?? 'All Prompts';

    if (altLibName != null) {
      return '$mode · $lib ↔ $altLibName';
    }
    return '$mode · $lib';
  }
}
