import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/main/main_screen.dart';
import '../features/settings/settings_sheet.dart';
import '../features/library/library_screen.dart';
import '../features/sequence/sequence_screen.dart';
import '../features/blackout/blackout_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsSheet(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/sequences',
        builder: (context, state) => const SequenceScreen(),
      ),
      GoRoute(
        path: '/blackout',
        builder: (context, state) => const BlackoutScreen(),
      ),
    ],
  );
});
