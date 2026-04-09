import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/main/main_screen.dart';
import '../features/library/library_screen.dart';
import '../features/sequence/sequence_screen.dart';
import '../features/blackout/blackout_screen.dart';
import '../features/about/about_screen.dart';
import '../models/library.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/library/detail',
        builder: (context, state) =>
            LibraryDetailScreen(library: state.extra as Library),
      ),
      GoRoute(
        path: '/sequences',
        builder: (context, state) => const SequenceScreen(),
      ),
      GoRoute(
        path: '/blackout',
        builder: (context, state) => const BlackoutScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
