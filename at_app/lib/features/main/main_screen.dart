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
          child: Stack(
            children: [
              // App name
              Positioned(
                top: 52 - MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    AppFlavor.appDisplayName.toUpperCase(),
                    style: isNight
                        ? AppTextStyles.appNameNight
                        : AppTextStyles.appNameDay,
                  ),
                ),
              ),

              // Settings gear
              Positioned(
                top: 52 - MediaQuery.of(context).padding.top,
                right: 28,
                child: GestureDetector(
                  onTap: () => context.push('/settings'),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 22,
                    color: AppColors.tealPrimary.withOpacity(0.55),
                  ),
                ),
              ),

              // Status text
              Positioned(
                top: 86 - MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    statusText,
                    style: isNight
                        ? AppTextStyles.statusNight
                        : AppTextStyles.statusDay,
                  ),
                ),
              ),

              // Orb + ripple rings (centered between top 102 and bottom 228)
              Positioned(
                top: 102 - MediaQuery.of(context).padding.top,
                bottom: 228,
                left: 0,
                right: 0,
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

              // Prompt text
              Positioned(
                bottom: 248,
                left: 0,
                right: 0,
                child: Center(
                  child: PromptTextWidget(text: _lastPromptText),
                ),
              ),

              // Countdown
              Positioned(
                bottom: 185,
                left: 0,
                right: 0,
                child: Center(
                  child: CountdownDisplay(
                    remaining: remaining,
                    visualMode: settings.visualMode,
                    isRunning: isRunning && !isPaused,
                  ),
                ),
              ),

              // Controls
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: MainControls(
                  isRunning: isRunning,
                  isPaused: isPaused,
                  onStartStop: () => _handleStartStop(settings),
                  onFireNow: () => PromptTimerService().fireNow(),
                  onSkipForward: () => PromptTimerService().fireNow(),
                  onSkipBack: () => PromptTimerService().skipBack(),
                  onPauseResume: () => _handlePauseResume(settings),
                ),
              ),
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

  Future<void> _handlePauseResume(AppSettings settings) async {
    final notifier = ref.read(settingsNotifierProvider.notifier);
    if (settings.isPaused) {
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
