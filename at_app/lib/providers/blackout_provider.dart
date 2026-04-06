import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/blackout_window.dart';
import 'repository_providers.dart';

const _uuid = Uuid();

final blackoutWindowsProvider = StreamProvider<List<BlackoutWindow>>((ref) {
  return ref.watch(blackoutRepositoryProvider).watchAll();
});

class BlackoutNotifier extends AsyncNotifier<List<BlackoutWindow>> {
  @override
  Future<List<BlackoutWindow>> build() async {
    return ref.watch(blackoutRepositoryProvider).getAll();
  }

  Future<void> addWindow({
    required String label,
    required List<int> days,
    required String startTime,
    required String endTime,
  }) async {
    final w = BlackoutWindow()
      ..uid = _uuid.v4()
      ..label = label
      ..daysOfWeek = days
      ..startTime = startTime
      ..endTime = endTime;
    await ref.read(blackoutRepositoryProvider).save(w);
  }

  Future<void> updateWindow(BlackoutWindow window) async {
    await ref.read(blackoutRepositoryProvider).save(window);
  }

  Future<void> deleteWindow(String uid) async {
    await ref.read(blackoutRepositoryProvider).delete(uid);
  }
}

final blackoutNotifierProvider =
    AsyncNotifierProvider<BlackoutNotifier, List<BlackoutWindow>>(
        BlackoutNotifier.new);
